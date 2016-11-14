"""
Project:        Cleaning_BAO_Data
File:           scrape_bao.py
Author:         Ryan Boyer
Email:          bcr5af@virginia.edu

Description:    This file contains the routines to import the BAO HTML,
scrape out the data, transform it into standard form, and export to .csv


Changelog:      Initial Version 2016 11 14
"""

from bs4 import BeautifulSoup as bs4
import os


def import_html_file(path):
    if os.path.isfile(path=path):
        with open(path, mode='r') as f:
            lines = f.read()
        return lines
    else:
        return False

def main():
    doc_tags = {"grocery":("/Users/Ryan/Documents/003_Charlottesville/UVA"
                           "/2016 Fall Semester/PLAN5120_GIS/Final_Project/"
                           "data/BAO/business/AtlantaGroceryStores.html"),
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


if __name__ == "__main__":
    main()