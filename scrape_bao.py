"""
Project:        Cleaning_BAO_Data
File:           scrape_bao.py
Author:         Ryan Boyer
Email:          bcr5af@virginia.edu

Description:    This file contains the routines to import the BAO HTML,
scrape out the data, transform it into standard form, and export to .csv


Changelog:      Initial Version 2016 11 14
"""

import os
import pandas as pd
import bs4

# Globals
field_tags = ["Name", "Street", "City", "State_Name", "Zip", "NAICS", "SIC",
              "Employee_Number", "Sales_Volume", "Latitude", "Longitude",
              "Object_ID", "Description"]
field_tag_dict = {"Name": ("dgrid-cell dgrid-cell-padding "
                           "dgrid-column-field1 field-CONAME field1"),
                  "Street": ("dgrid-cell dgrid-cell-padding "
                             "dgrid-column-field2 field-STREET field2"),
                  "City": ("dgrid-cell dgrid-cell-padding "
                           "dgrid-column-field3 field-CITY field3"),
                  "State_Name": ("dgrid-cell dgrid-cell-padding "
                                 "dgrid-column-field4 field-STATE_NAME field4"),
                  "Zip": ("dgrid-cell dgrid-cell-padding "
                          "dgrid-column-field5 field-ZIP field5"),
                  "NAICS": ("dgrid-cell dgrid-cell-padding "
                            "dgrid-column-field6 field-NAICS field6"),
                  "SIC": ("dgrid-cell dgrid-cell-padding "
                          "dgrid-column-field7 field-SIC field7"),
                  "Employee_Number": ("dgrid-cell dgrid-cell-padding "
                                      "dgrid-column-field8 field-EMPNUM "
                                      "field8"),
                  "Sales_Volume": ("dgrid-cell dgrid-cell-padding "
                                   "dgrid-column-field9 field-SALESVOL field9"),
                  "Latitude": ("dgrid-cell dgrid-cell-padding "
                               "dgrid-column-field11 field-LATITUDE field11"),
                  "Longitude": ("dgrid-cell dgrid-cell-padding "
                                "dgrid-column-field12 field-LONGITUDE field12"),
                  "Object_ID": ("dgrid-cell dgrid-cell-padding "
                                "dgrid-column-field0 field-OBJECTID field0"),
                  "Description": ("dgrid-cell dgrid-cell-padding "
                                  "dgrid-column-field10 field-DESC_ field10")
              }


def import_html_file(path):
    """
    :param path:
    :return:
    """
    if os.path.isfile(path=path):
        with open(path, mode='r') as f:
            lines = f.read()
        return lines
    else:
        return False


def get_data(tag, files):
    """
    Takes each file in the files list, scrapes BAO data out of it
    and transforms into a single pandas DF.

    :param tag: type of tag, as string
    :param files: list of file paths
    :return: pandas dataframe, error flag
    """
    data = pd.dataframe()
    error_flag = False
    error_files = []
    for file in files:
        if os.path.isfile(file):
            soup = bs4.BeautifulSoup(open(file), "lxml")
        else:
            error_flag = True
            error_files.append(file)
    return (data, error_flag, error_files)


def main():
    # Get Data
    doc_tags = {"grocery": [
                    ("/Users/Ryan/Documents/003_Charlottesville/UVA/2016 "
                     "Fall Semester/PLAN5120_GIS/Final_Project/data/BAO/"
                     "business/AtlantaGroceryStores.html")],
                "restaurant": [
                    ("/Users/Ryan/Documents/003_Charlottesville/UVA/2016 "
                     "Fall Semester/PLAN5120_GIS/Final_Project/data/BAO"
                     "/business/Restaurants(1).html"),
                    ("/Users/Ryan/Documents/003_Charlottesville/UVA/2016 "
                     "Fall Semester/PLAN5120_GIS/Final_Project/data/BAO"
                     "/business/Restaurants(2).html"),
                    ("/Users/Ryan/Documents/003_Charlottesville/UVA/2016 "
                     "Fall Semester/PLAN5120_GIS/Final_Project/data/BAO"
                     "/business/Restaurants(3).html"),
                    ("/Users/Ryan/Documents/003_Charlottesville/UVA/2016 "
                     "Fall Semester/PLAN5120_GIS/Final_Project/data/BAO"
                     "/business/Restaurants(4).html"),
                    ("/Users/Ryan/Documents/003_Charlottesville/UVA/2016 "
                     "Fall Semester/PLAN5120_GIS/Final_Project/data/BAO"
                     "/business/Restaurants(5).html")
                ]
                }

    #Get data
    for key in doc_tags:
        tag = key
        files = doc_tags[key]
        (data, error_flag, error_files) = get_data(tag, files)


if __name__ == "__main__":
    main()
