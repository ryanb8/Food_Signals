"""
Project:        Cleaning_BAO_Data
File:           scrape_bao.py
Author:         Ryan Boyer
Email:          bcr5af@virginia.edu

Description:    This file contains the routines to import the BAO HTML,
scrape out the data, transform it into standard form, and export to .csv

Depends on:
os
BeautifulSoup (bs4)
pandas
html5lib


Changelog:      Initial Version 2016 11 14
                Final Version 2016 11 15
"""

import os
import pandas as pd
import bs4

# Globals
table_tag = "td"
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
                                 "dgrid-column-field4 "
                                 "field-STATE_NAME field4"),
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
                                   "dgrid-column-field9 "
                                   "field-SALESVOL field9"),
                  "Latitude": ("dgrid-cell dgrid-cell-padding "
                               "dgrid-column-field11 "
                               "field-LATITUDE field11"),
                  "Longitude": ("dgrid-cell dgrid-cell-padding "
                                "dgrid-column-field12 "
                                "field-LONGITUDE field12"),
                  "Object_ID": ("dgrid-cell dgrid-cell-padding "
                                "dgrid-column-field0 field-OBJECTID field0"),
                  "Description": ("dgrid-cell "
                                  "dgrid-cell-padding "
                                  "dgrid-column-field10 field-DESC_ field10")
                  }


def get_data(files):
    """
    Takes each file in the files list, scrapes BAO data out of it
    and transforms into a single pandas DF.

    :param files: list of file paths
    :return: pandas dataframe, error flag
    """
    error_flag = False
    error_files = []
    data_list = []
    for file in files:
        print("file is")
        print(file)
        print("\n")
        if os.path.isfile(file):
            soup = bs4.BeautifulSoup(open(file), "html5lib")
            data = {}
            for i in range(len(field_tags)):
                tag = field_tags[i]
                all_tags = soup.find_all(table_tag, attrs=field_tag_dict[tag])
                data[tag] = [tag.string for tag in all_tags]
            print("making data frame")
            data_list.append(pd.DataFrame(data))
        else:
            error_flag = True
            error_files.append(file)
    data = pd.concat(data_list)
    data = data[field_tags]
    data = data.sort_values(by=[field_tags[0], field_tags[8]],
                            axis=0,
                            ascending=[True, False])
    return data, error_flag, error_files


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

    # Get data
    all_data = []
    for key in doc_tags:
        files = doc_tags[key]
        (data, error_flag, error_files) = get_data(files)
        all_data.append(data)
        print("Error flag for {} key was {}".format(key, error_flag))
        if error_flag:
            print("Files with errors are: {}".format(error_files))
            print(error_files)
        print("data length was")
        print(len(data))

    # export data
    for i in range(len(all_data)):
        fpath = "/Users/Ryan/Desktop/bao" + str(i) + ".csv"
        all_data[i].to_csv(path_or_buf=fpath,
                           sep=",")

if __name__ == "__main__":
    main()
