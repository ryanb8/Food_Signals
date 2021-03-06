# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# FP_20162516.py
# Created on: 2016-11-25 15:28:39.00000
#   (generated by ArcGIS/ModelBuilder)
# Updated by Ryan Boyer on 2016-11-25
#   as Model Builder is struggling with iterated loops
#   and inline variable names
# Description:
#  Takes a collection of point data sets and a collection of buffer values.
#  For each point and buffer value pair,
# Usage: FP_20162516 <D> <GS_In_ACR> <g_or_r>
#   Load into an ArcMap Tool box, and follow prompts
# Inputs:
#   D: Buffer distances e.g 0.25, 0.5, etc. with unit set in ArcMap
#   GS_In_ACR: Point data sets of establishments
#   Data_for_Clip: Layer with census tracts & data (for clipping)
#   output: file path to write CSV
#
# Updated on 01/01/2017
# NOTE: As my access to ArcMap is gone, I am unable to truly clean and test
# this code. Thus, I am leaving it in its current state and only adding a
# few comments to explain the code's process.
# ---------------------------------------------------------------------------

# Import modules
import arcpy
import os
import string
import csv
import domainvalues

# Load required toolboxes
arcpy.ImportToolbox("C:/Users/Ryan "
                    "Boyer/Documents/PLAN5120/downloaded_tolls/ExcelTools"
                    "/Excel and CSV Conversion Tools.tbx")
# arcpy.ImportToolbox(
#     "C:/Users/Ryan Boyer/Documents/PLAN5120/downloaded_tools/ExcelTools/Excel and CSV Conversion Tools.tbx")

# Script arguments
# Set Buffer_Distance - Set to multiple in script parameters and pass all
# desired distances
D = arcpy.GetParameter(0)
arcpy.AddMessage(D)  # Show to user
arcpy.AddMessage(len(D))
if D == '#' or not D:
    D = "0.25 Miles"  # provide a default value if unspecified

# Grocery Stores or Restaurants Data - Set to multiple in script parameters
# and pass both
GS_In_ACR = arcpy.GetParameterAsText(1)
arcpy.AddMessage(GS_In_ACR)  # Show to user
# provide a default value if unspecified  - "GS_In_ACR" is a layer in
# original data set - BUG: This won't generalize
if GS_In_ACR == '#' or not GS_In_ACR:
    GS_In_ACR = "GS_In_ACR"
GS_In_ACR = GS_In_ACR.split(";")
arcpy.AddMessage(GS_In_ACR)

# Move point data into local memory for speed
GS_In_ACR_in_mem = GS_In_ACR
for num in range(len(GS_In_ACR_in_mem)):
    arcpy.AddMessage(num)
    arcpy.MakeFeatureLayer_management(GS_In_ACR_in_mem[num],
                                      "in_memory\base_layer" + str(num))
    my_str = 'in_memory\base_layer' + str(num)
    GS_In_ACR_in_mem[num] = my_str

# Data for Clip (backboard)
Data_for_Clip = arcpy.GetParameterAsText(2)
arcpy.AddMessage(Data_for_Clip)
# move into local memory
arcpy.MakeFeatureLayer_management(Data_for_Clip, "in_memory\Data_for_Clip")
Data_for_Clip = "in_memory\Data_for_Clip"

# Data Output
output = arcpy.GetParameterAsText(3)
arcpy.AddMessage(output)

# Alert user to number of points
arcpy.AddMessage("length of D")
arcpy.AddMessage(len(D))

# Temp Variables --> Rename in_memory variables in precedent of ArcMap Model
#  Builder
#  BUG: this could & should be simplified
Grocery_Stores_Buffer = "in_memory\Buffers"
Grocery_Stores_Buffer_Clip = "in_memory\BuffersClip"

# Header
header_flag = False

# Iterate through buffers
i = 0  # Count index for progress bar - Buffer Values
for D_value in D:
    # Iterate through Point Data Sets
    j = 0  # Count index for progress bar - Point Data Sets
    for I_GS_In_ACR_OBJECTID in GS_In_ACR_in_mem:
        # Tell user which data set & dat set type
        arcpy.AddMessage(type(I_GS_In_ACR_OBJECTID))
        arcpy.AddMessage(I_GS_In_ACR_OBJECTID)
        # Select Data Set
        arcpy.SelectLayerByAttribute_management(I_GS_In_ACR_OBJECTID,
                                                "CLEAR_SELECTION")
        rows = arcpy.SearchCursor(I_GS_In_ACR_OBJECTID)
        count = 1
        # Iterate through points in data set
        for row in rows:
            # select Specific Point:
            # Syntax : SelectLayerByAttribute_management (in_layer_or_view,
            #   {selection_type}, {where_clause}, {invert_where_clause})
            arcpy.SelectLayerByAttribute_management(I_GS_In_ACR_OBJECTID,
                                                    "NEW_SELECTION",
                                                    "\"OBJECTID\" = " + str(
                                                        count))

            # Create Buffer Around Point
            # Syntax : Buffer_analysis (in_features, out_feature_class,
            #   buffer_distance_or_field, {line_side}, {line_end_type},
            #   {dissolve_option}, {dissolve_field}, {method})
            arcpy.Buffer_analysis(I_GS_In_ACR_OBJECTID,
                                  Grocery_Stores_Buffer,
                                  D_value, "FULL", "ROUND", "NONE", "",
                                  "PLANAR")

            # Clip from Base layer within point's buffer --> results in
            #   clipped census tracts retained within buffer
            # Syntax : Clip_analysis (in_features, clip_features,
            #   out_feature_class, {cluster_tolerance})
            arcpy.Clip_analysis(Data_for_Clip,
                                Grocery_Stores_Buffer,
                                Grocery_Stores_Buffer_Clip, "")

            # Add Attributes to attribute table of clipped tracts:
            #   retain these values for calculation of per capita income etc.
            # Syntax : AddField_management (in_table, field_name,
            #   field_type,  {field_precision}, {field_scale}, {field_length},
            #   {field_alias}, {field_is_nullable}, {field_is_required},
            #   {field_domain})
            # Syntax : CalculateField_management (in_table, field, expression,
            #   {expression_type}, {code_block})
            # Area
            arcpy.AddField_management(Grocery_Stores_Buffer_Clip, "new_area",
                                      "DOUBLE", "", "", "", "", "NULLABLE",
                                      "NON_REQUIRED", "")
            # Area is in Square Yards
            arcpy.CalculateField_management(Grocery_Stores_Buffer_Clip,
                                            "new_area",
                                            "!shape.area@SQUAREYARDS!",
                                            "PYTHON_9.3", "")

            # buffer_val
            arcpy.AddField_management(Grocery_Stores_Buffer_Clip, "buffer_val",
                                      "STRING", "", "", "", "", "NULLABLE",
                                      "NON_REQUIRED", "")
            buf_val = "\"" + str(D_value) + "\""
            arcpy.CalculateField_management(Grocery_Stores_Buffer_Clip,
                                            "buffer_val", buf_val,
                                            "PYTHON_9.3", "")

            # Point_Layer
            arcpy.AddField_management(Grocery_Stores_Buffer_Clip,
                                      "point_layer", "STRING", "", "", "", "",
                                      "NULLABLE", "NON_REQUIRED", "")
            point_lay_val = "\"" + str(I_GS_In_ACR_OBJECTID)[-6:] + "\""
            arcpy.CalculateField_management(Grocery_Stores_Buffer_Clip,
                                            "point_layer", point_lay_val,
                                            "PYTHON_9.3", "")

            # Point Obj_ID
            arcpy.AddField_management(Grocery_Stores_Buffer_Clip, "point_id",
                                      "STRING", "", "", "", "", "NULLABLE",
                                      "NON_REQUIRED", "")
            point_id_val = "\"" + str(row.getValue("OBJECTID")) + "\""
            arcpy.CalculateField_management(Grocery_Stores_Buffer_Clip,
                                            "point_id", point_id_val,
                                            "PYTHON_9.3", "")

            # Point Name
            arcpy.AddField_management(Grocery_Stores_Buffer_Clip, "point_name",
                                      "STRING", "", "", "", "", "NULLABLE",
                                      "NON_REQUIRED", "")
            point_name_val = "\"" + str(row.getValue("Name")) + "\""
            arcpy.CalculateField_management(Grocery_Stores_Buffer_Clip,
                                            "point_name", point_name_val,
                                            "PYTHON_9.3", "")

            # Point Description
            arcpy.AddField_management(Grocery_Stores_Buffer_Clip, "point_desc",
                                      "STRING", "", "", "", "", "NULLABLE",
                                      "NON_REQUIRED", "")
            point_desc_val = "\"" + str(row.getValue("Description")) + "\""
            arcpy.CalculateField_management(Grocery_Stores_Buffer_Clip,
                                            "point_desc", point_desc_val,
                                            "PYTHON_9.3", "")

            # Increase point count:
            count += 1

            # Write clipped census tract data to CSV:
            # Prep writer and data
            out_writer = csv.writer(open(output, 'ab'), dialect='excel')
            header, rows2 = domainvalues.header_and_iterator(
                Grocery_Stores_Buffer_Clip)
            # Write to file
            if not header_flag:
                out_writer.writerow(map(domainvalues._encodeHeader, header))
                header_flag = True
            for row2 in rows2:
                out_writer.writerow(map(domainvalues._encode, row2))

        # Alert user on progress
        arcpy.AddMessage("{0} of {1} buffers".format(i + 1, len(D)))
        arcpy.AddMessage("{0} of {1} point sets".format(j + 1, len(GS_In_ACR)))
        arcpy.AddMessage("Pass {0} of {1}".format(i * len(GS_In_ACR) + j + 1,
                                                  len(D) * len(GS_In_ACR)))
        # Update progress count: Point Data Sets
        j += 1
    # Update progress count: Buffer values
    i += 1
