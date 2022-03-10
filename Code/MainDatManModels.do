///////////////////////////////////////
// SPANISH LIFE TABLES BY DEPRIVATION
//////////////////////////////////////

*! version 1.0 19.February.2021
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


/*
Available data sources:
A) Population by census tracts, year, sex and age groups (five years) in Spain
Año 2011: http://www.ine.es/dynt3/inebase/es/index.htm?type=pcaxis&file=pcaxis&path=%2Ft20%2Fe245%2Fp07%2F%2Fa2011 
Año 2012: http://www.ine.es/dynt3/inebase/es/index.htm?type=pcaxis&file=pcaxis&path=%2Ft20%2Fe245%2Fp07%2F%2Fa2012
Año 2013: http://www.ine.es/dynt3/inebase/es/index.htm?type=pcaxis&file=pcaxis&path=%2Ft20%2Fe245%2Fp07%2F%2Fa2013
B) Deaths by census tracts, year, sex and age in Spain
          http://www.ine.es
*/

// DATA MANAGMENT and CHECKS
set processors 4
clear

forvalues i = 1(1)3 {
  clear
  import delimited "/Users/MALF/Dropbox/EASP/FIS2018/Data/Mortalidad/ALLCause/04_Cruce_con_SDI/dfpof201`i'.csv", asdouble encoding(UTF-8) parselocale(en_US) stringcols(2) 
  destring sdi, gen(SDI) force
  rename valor pop
  rename año year
  rename gedad age
  rename sexo sex
  keep sc sex age year pop def SDI
  compress

preserve
 keep if sex == "hombres"
 save male201`i', replace
restore
 
preserve
  keep if sex == "mujeres"
 save female201`i', replace
restore
} 

//clear 
//use male2013
//tostring sc, gen(SC)
//drop sc 
//rename SC sc
//save male2013, replace

//clear
//use female2013
//tostring sc, gen(SC)
//drop sc 
//rename SC sc
//save female2013, replace

// Count census tracts (cs) 2011/13 in Population file
clear
forvalues i = 1(1)3 {
clear
use Pop201014
keep if year == 201`i'
bys sc: gen n = _n
bys sc: gen N = _N
gen countsc = 1 if n==N
bys year: tab countsc, miss
}

// Count cs 2011/13 in Population file
clear
use ip2011
bys sc: gen n = _n
bys sc: gen N = _N
gen countsc = 1 if n==N
tab countsc, miss

// Count cs 2011/13 males after linkage with mortality, population and 2011 census data
clear 
forvalues i = 1(1)3 {
	clear
    use male201`i' 
preserve
//list if pop  == 0  & def>=1 
//drop if pop  == 0 //Drop non-linked census tracts 
//drop if qsdi == . //Drop non-linked census tracts 
sort sc
bysort sc: gen n = _n
bysort sc: gen N = _N
gen countsc = 1 if n==N
bys year: tab countsc, miss
describe
tabstat def pop if year==201`i', by(age) stat(sum)
restore
}

// Count cs 2011/13 females after linkage with mortality, population and 2011 census data
clear 
forvalues i = 1(1)3 {
	clear
    use female201`i' 
preserve
//drop if pop  == 0 //Drop non-linked census tracts 
//drop if qsdi == . //Drop non-linked census tracts 
sort sc
bysort sc: gen n = _n
bysort sc: gen N = _N
gen countsc = 1 if n==N
bys year: tab countsc, miss
restore
}

/*
(8 vars, 1,294,560 obs)
sdi: contains nonnumeric characters; SDI generated as double
(108 missing values generated)
 
sdi: contains nonnumeric characters; SDI generated as double
(2268 missing values generated)

sdi: contains nonnumeric characters; SDI generated as double
(7308 missing values generated)
 
sdi: contains nonnumeric characters; SDI generated as double
(18864 missing values generated)
*/

clear 
use male2011
forvalues i = 2(1)3 {
     append using male201`i'
  }
xtile qsdi = SDI, nq(5) // ref three year period 
keep sc age def pop qsdi year
collapse (sum) def (mean) pop , by(sc age qsdi)
gen Pop = round(pop)
drop pop
//gen obsMR = def/pop
//drop year
save male1113, replace

clear 
use female2011
forvalues i = 2(1)3 {
     append using female201`i'
  }
xtile qsdi = SDI, nq(5) // ref three year period  
keep sc age def pop qsdi year
collapse (sum) def (mean) pop, by(sc age qsdi)
gen   Pop = round(pop)
drop pop
//gen obsMR = def/pop
//drop year
save female1113, replace

////////////////////////
// Modeling MALES
////////////////////////

clear
use male1113
destring sc, gen(ct)
format %10.0f ct
replace age = "10-10" if age =="5-9" // ordered label list
tab age
encode age, gen(Age)
label list Age

list if Pop  == 0  & def>=1 // Check (Deaths outside the country)
drop if Pop  == 0  & def>=1
drop if Pop == 0
drop if qsdi == . // Drop non-linked census tracts 

// Checking consistency
// sort qsdi sc age
sort sc age
bysort sc(age): gen cstr = 1 if _n==1
replace cstr = sum(cstr)
replace cstr = . if missing(cstr)

duplicates report cs cstr

// Replace age with its mid interval value 2, 7, 12, 17, etc for modelling linear effect of age
recode Age (1 = 2) (2 = 7) (3 = 12) (4 = 17) (5 = 22) (6 = 27) (7 = 32) (8 = 37) (9 = 42) ///
(10 = 47) (11 = 52) (12 = 57) (13 = 62) (14 = 67) (15 = 72) (16 = 77) (17 = 82) (18 = 85)
label val Age 

// Find best position for the Knots using different positions based on the crossvalidated rmse

rcsgen Age, knots(2 12 22 32 42 52 67 82) gen(rcsa) center(60) ortho
//rcsgen Age, knots(2 22 42 62 82) gen(rcsb) ortho
//rcsgen Age, knots(2 32 62 82) gen(rcsc) center(60) ortho
//rcsgen Age, knots(2 47 82) gen(rcsd) center(60) ortho

//crossfold glm def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) eform mae // mae 0.92: Chosen model based on mae
//crossfold glm def rcsb* i.qsdi c.rcsb*#i.qsdi, exposure(Pop) eform mae // mae 0.94
//crossfold glm def rcsc* i.qsdi c.rcsc*#i.qsdi, exposure(Pop) eform mae // mae 0.94
//crossfold glm def rcsd* i.qsdi c.rcsd*#i.qsdi, exposure(Pop) eform mae // mae 0.96

// Chosen model based on MAE 
// glm def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) eform  

// Improved model accouting for random intercept from census tracts (decreasing overdispersion)
// crossfold xtpoisson def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) i(ct) irr normal mae 
xtpoisson def c.rcsa*##i.qsdi, exposure(Pop) i(ct) irr normal
// xtpoisson def rcsa*, exposure(Pop) i(ct) irr normal

//predict cmr, iru0   // Rates assuming random intercep = zero
predict deaths, n   // Predict number of deaths accouting for random intercetp 

gen obsMR = (def/Pop*100000)  // observed MR
gen predMR = (deaths/Pop*100000) // predicted MR  

save maleLFT, replace

// Observed mortality rates
preserve
collapse (mean) obsMR (mean) predMR, by(Age qsdi)
// Replace obsR = exp(obsR) 
gen lnobsMR = ln(obsMR)
tw(line lnobsMR Age if qsdi==1)(line lnobsMR Age if qsdi==2)(line lnobsMR Age if qsdi==3) /// 
(line lnobsMR Age if qsdi==4)(line lnobsMR Age if qsdi==5), saving(maleobsMR)

// Visual check goodness of fit
gen a = ln(obsMR)
gen b = ln(predMR)
tw(scatter a Age if qsdi==1)(line b Age if qsdi==1), saving(a) 
tw(scatter a Age if qsdi==2)(line b Age if qsdi==2), saving(b) 
tw(scatter a Age if qsdi==3)(line b Age if qsdi==3), saving(c) 
tw(scatter a Age if qsdi==4)(line b Age if qsdi==4), saving(d)
tw(scatter a Age if qsdi==5)(line b Age if qsdi==5), saving(e) 
graph combine  a.gph b.gph c.gph d.gph e.gph, saving(MobsPredPanel)
restore

////////////////////////
// Modeling FEMALES
////////////////////////
clear
use female1113
destring sc, gen(ct)
format %10.0f ct
replace age = "10-10" if age =="5-9" // ordered label list
tab age
encode age, gen(Age)
label list Age

// Checking consistency
sort qsdi sc age
bysort sc(age): gen cstr = 1 if _n==1
replace cstr = sum(cstr)
replace cstr = . if missing(cstr)

duplicates report cs cstr

list if Pop  == 0  & def>=1 // Check (Deaths outside the country)
drop if Pop  == 0 // Drop non-linked census tracts 
drop if qsdi == . // Drop non-linked census tracts 

// Replace age with its mid interval value 2, 7, 12, 17, etc for modelling linear effect of age
recode Age (1 = 2) (2 = 7) (3 = 12) (4 = 17) (5 = 22) (6 = 27) (7 = 32) (8 = 37) (9 = 42) ///
(10 = 47) (11 = 52) (12 = 57) (13 = 62) (14 = 67) (15 = 72) (16 = 77) (17 = 82) (18 = 85)
label val Age 

// Find best position for the Knots using different positions based on the crossvalidated rmse

rcsgen Age, knots(2 12 22 32 42 52 67 82) gen(rcsa) center(60) ortho
//rcsgen Age, knots(2 22 42 62 82) gen(rcsb) center(60) ortho
//rcsgen Age, knots(2 32 62 82) gen(rcsc) center(60) ortho
//rcsgen Age, knots(2 47 82) gen(rcsd) center(60) ortho

//crossfold glm def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) eform mae // mae 0.92: Chosen model based on mae
//crossfold glm def rcsb* i.qsdi c.rcsb*#i.qsdi, exposure(Pop) eform mae // mae 0.94
//crossfold glm def rcsc* i.qsdi c.rcsc*#i.qsdi, exposure(Pop) eform mae // mae 0.94
//crossfold glm def rcsd* i.qsdi c.rcsd*#i.qsdi, exposure(Pop) eform mae // mae 0.96

// Chosen model based on MAE 
//glm def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) eform  

// Improved model accouting for random intercept from census tracts (decreasing overdispersion)
// crossfold xtpoisson def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) i(ct) irr normal mae 
xtpoisson def rcsa* i.qsdi c.rcsa*#i.qsdi, exposure(Pop) i(ct) irr normal

// Predict pdef, iru0  // Rates assuming random intercep = zero
predict deaths, n     // Predict number of deaths accouting for random intercetp 

gen obsMR = (def/Pop*100000)  // observed MR
gen   predMR = (deaths/Pop*100000) // predicted MR  
save femaleLFT, replace

// Observed mortality rates
preserve
collapse (mean) obsMR (mean) predMR, by(Age qsdi)
// Replace obsR = exp(obsR) 
gen lnobsMR = ln(obsMR)
tw(line lnobsMR Age if qsdi==1)(line lnobsMR Age if qsdi==2)(line lnobsMR Age if qsdi==3) /// 
(line lnobsMR Age if qsdi==4)(line lnobsMR Age if qsdi==5), saving(FemaleobsMR)

// Visual check goodness of fit
gen a = ln(obsMR)
gen b = ln(predMR)
tw(scatter a Age if qsdi==1)(line b Age if qsdi==1), saving(fa)
tw(scatter a Age if qsdi==2)(line b Age if qsdi==2), saving(fb)
tw(scatter a Age if qsdi==3)(line b Age if qsdi==3), saving(fc)
tw(scatter a Age if qsdi==4)(line b Age if qsdi==4), saving(fd)
tw(scatter a Age if qsdi==5)(line b Age if qsdi==5), saving(fe)
graph combine  fa.gph fb.gph fc.gph fd.gph fe.gph, saving(FobsPredPanel)
restore


