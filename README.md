# Spanish Abridged Life Tables by sex, age, and socioeconomic status, 2011-2013  
An ordinary **life table** is a statistical tool that summarizes the mortality experience of a population and yields information about longevity and life expectation. Life tables in *population-based cancer epidemiology* are an important tool used to compute the net survival or probability of dying due to cancer in a given population. Complete life tables are published by sex and age at a national level on a regular basis. Furthermore, because background mortality can vary widely by socioeconomic status, it is desirable to be able to produce life tables specific to these populations in order to better understand how mortality varies within them. To be able to produce net survival estimates by socioeconomic status life tables by sex, age and socioeconomic status are needed.  

Using Spanish population and mortality data by census tract level, age, calendar year, and the quintiles (where Q5 represents the most deprived areas and Q1 the less deprived areas) of the Spanish Deprivation Index (SDI) (an index created using data from the Spanish 2011 census conducted by the Spanish National Statistics Institute), we created the first abridged Spanish Life Tables by deprivation for the period 2011-2013.   

This repository provides the code to reproduce the creation of the first smoothed life tables containing age specific deprivation standardised mortality rates and life expectancy, by sex, age groups, deprivation quintile and census tract in Spain 2011-2013. **"Smoothed life tables"** were created, using restricted cubic splines in an exponential flexible mixed effects Poisson regression model [1,2].  

1. Rachet, B., Maringe, C., Woods, L.M. et al. (2015) Multivariable flexible modelling for estimating complete, smoothed life tables for sub-national populations. BMC Public Health 15, 1240 (2015). https://doi.org/10.1186/s12889-015-2534-3  

2. Luque-Fernandez, MA., Belot, A., Quaresma, M., Maringe, C., Coleman, M. P., & Rachet, B. (2016). Adjusting for overdispersion in piecewise exponential regression models to estimate excess mortality rate in population-based research. BMC medical research methodology, 16(1), 129. https://doi.org/10.1186/s12874-016-0234-z

# Authors  
[Author and Developer]
Miguel Angel Luque-Fernandez, LSHTM, NCDE, ICON Group, London, UK    
Email: miguel-angel.luque@lshtm.ac.uk 

# Contributors  

 
# Updates
In case you have updates or changes that you would like to make, please send me a pull request.  
Alternatively, if you have any questions, please e-mail me:   
Miguel Angel Luque-Fernandez    
E-mail: miguel-angel.luque at lshtm.ac.uk  
Twitter @WATZILEI  

# Citation    
You can cite this repository as:  
Luque-Fernandez MA (2021). Spanish Abridged Life Tables by sex, age and deprivation, 2011-2013. GitHub repository, https://github.com/migariane/Spanish_LifeTablesByDeprivation         

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4662660.svg)](https://doi.org/10.5281/zenodo.4662660)

# Copyright
This software is distributed under the MIT license.

# Acknowledgments  
Miguel Angel Luque-Fernandez is supported by a Miguel Servet I Investigator award (Grant CP17/00206) and a project grant EU-FEDER-FIS PI-18/01593 from the Instituto de Salud Carlos III, Madrid, Spain.   

![Figure Link](https://github.com/migariane/Spanish_LifeTablesByDeprivation/blob/main/Acknowledgment.png)   
https://github.com/migariane/Spanish_LifeTablesByDeprivation/blob/main/Acknowledgment.png