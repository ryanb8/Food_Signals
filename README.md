# Food_Signals
**Ryan Boyer**  
**University of Virginia**  
**PLAN5120 Final Project - Fall 2016**   

This contains all the components used to do spatial analysis of chain restaurants and grocery stores in the Atlanta-Metro area **to identify chains that signal high and low income areas.** There are three major components in the project:
* Web Scraping Components (Python with Beautiful Soup 4) for scraping ESRI's Business Analyst Online
* ArcPy Scripts (Python with ArcPy) for doing an iterated buffer analys on each establishment
* Aggregating Scripts (R with dplyr, ggplot2, gganimate) for aggregating census tract data to establishments to chains

## Use

Functionally, this complete project has value only in its use for other cities and regions to do similar analysis.

However, the code portions could be used individually for similar tasks (e.g. scraping data from ESRI's BAO, or making similar graphs).

## Authors

* **Ryan Boyer** - *Initial work* - [ryanb8](https://github.com/ryanb8)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Big thanks to Dr. Guoping Huang for the excellent GIS class and letting me go technical on my project
