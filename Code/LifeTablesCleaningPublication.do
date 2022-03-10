///////////////////////////////////////
// SPANISH LIFE TABLES BY DEPRIVATION
//////////////////////////////////////

*! version 1.0 05.April.2021
*! update 9.3.22 
*! Abridged smoothed Life Tables by deprivation in Spain 2011-2013
*! by Miguel Angel Luque-Fernandez [cre, aut]
*! Bug reports: 
*! miguel-angel.luque at lshtm.ac.uk

/*
Copyright (c) 2022  <Miguel Angel Luque-Fernandez>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

// Male Life Table 
clear
use mablifetable
tostring age, gen(Agegroup)
replace Agegroup = "0-4" if Age == "2"
replace Agegroup = "05-09''" if Age == "7" 
replace Agegroup = "10-14''" if Age == "12" 
replace Agegroup = "15-19" if Age == "17" 
replace Agegroup = "20-24" if Age == "22"
replace Agegroup = "25-29" if Age == "27"
replace Agegroup = "30-34" if Age == "32"
replace Agegroup = "35-39" if Age == "37"
replace Agegroup = "40-44" if Age == "42"
replace Agegroup = "45-49" if Age == "47"
replace Agegroup = "50-54" if Age == "52"
replace Agegroup = "55-59" if Age == "57"
replace Agegroup = "60-64" if Age == "62"
replace Agegroup = "65-69" if Age == "67"
replace Agegroup = "70-74" if Age == "72"
replace Agegroup = "75-79" if Age == "77"
replace Agegroup = "80-84" if Age == "82"
replace Agegroup = "85+" if Age == "85"
drop age
drop cmr death Pop cstr 
drop Lx Tx 
gen px = 1-qx
rename sc Areacode
rename qsdi Deprivation_quintile
gen Sex = "Male"
order Areacode Deprivation_quintile Sex Agegroup Mortality_Rate lci uci qx px lx dx Ex 
drop n
export delimited using "/Users/MALF/Dropbox/EASP/FIS2018/Articles/3_THIRD_LIFETABLES/Analysis/LTMales.csv", replace

// Female Life Table 
clear
use fablifetable

tostring age, gen(Agegroup)
replace Agegroup = "0-4" if Age == "2"
replace Agegroup = "05-09''" if Age == "7" 
replace Agegroup = "10-14''" if Age == "12" 
replace Agegroup = "15-19" if Age == "17" 
replace Agegroup = "20-24" if Age == "22"
replace Agegroup = "25-29" if Age == "27"
replace Agegroup = "30-34" if Age == "32"
replace Agegroup = "35-39" if Age == "37"
replace Agegroup = "40-44" if Age == "42"
replace Agegroup = "45-49" if Age == "47"
replace Agegroup = "50-54" if Age == "52"
replace Agegroup = "55-59" if Age == "57"
replace Agegroup = "60-64" if Age == "62"
replace Agegroup = "65-69" if Age == "67"
replace Agegroup = "70-74" if Age == "72"
replace Agegroup = "75-79" if Age == "77"
replace Agegroup = "80-84" if Age == "82"
replace Agegroup = "85+" if Age == "85"
drop age
drop cmr death Pop cstr 
drop Lx Tx 
gen px = 1-qx
rename sc Areacode
rename qsdi Deprivation_quintile
gen Sex = "Female"
order Areacode Deprivation_quintile Sex Agegroup Mortality_Rate lci uci qx px lx dx Ex 
drop n
export delimited using "/Users/MALF/Dropbox/EASP/FIS2018/Articles/3_THIRD_LIFETABLES/Analysis/LTfemales.csv", replace
