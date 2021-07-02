///////////////////////////////////////
// SPANISH LIFE TABLES BY DEPRIVATION
//////////////////////////////////////

*! version 1.0 19.February.2021
*! Abridged smoothed Life Tables by deprivation in Spain 2011-2013
*! by Miguel Angel Luque-Fernandez [cre, aut]
*! Bug reports: 
*! miguel-angel.luque at lshtm.ac.uk

/*
Copyright (c) 2021  <Miguel Angel Luque-Fernandez>
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

clear
use femaleLFT
drop rcs* obsMR predMR
gen Mortality_Rate = deaths/Pop*100000
collapse (mean) deaths (mean) Pop (mean) Mortality_Rate, by(Age qsdi sc)
gen lci = Mortality_Rate - 1.96 * sqrt(Mortality_Rate / Pop)
gen uci = Mortality_Rate + 1.96 * sqrt(Mortality_Rate / Pop)
gen cmr = Mortality_Rate / 100000
gen qx  = 1 - (exp(-2*cmr))

sort qsdi sc Age
bysort sc(Age): gen n = _n

sort qsdi sc Age
bysort sc(Age qsdi): gen cstr = 1 if _n==1 
tab cstr // 35959  
replace cstr = sum(cstr)
replace cstr = . if missing(cstr)

gen lx = . if n == 1 
gen dx = . if n == 1
gen Lx = .
gen Tx = .
gen Ex = .

sort cstr qsdi Age
bysort cstr (Age): gen byte last = _n == _N 
expand 2 if last == 1 
sort cstr qsdi Age

bysort cstr (Age): replace lx = .  if _n == _N 
bysort cstr (Age): replace n = 19 if _n == _N 
drop last
rename Age age
gen Age = n 

//Check consistency with published official data from office National Statistics for only one province 
// gen prov = substr(sc,1,2)
// keep if prov == "18" 
// forval i = 12679(1)13333{
// forval i = 1(1)35959 {

sort cstr qsdi Age
 forval i = 1(1)35959 {
  replace lx = 100000   if n == 1  & cstr==`i'
  replace dx = (qx * lx) if n == 1  & cstr==`i'
  display "Number of records updated: `i'"

}

sort cstr qsdi Age n
  forval i = 1(1)35959 {
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 2 & cstr==`i'
		 replace dx = lx*qx if  Age==2 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 3 & cstr==`i'
		 replace dx = lx*qx if  Age==3 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 4 & cstr==`i'
		 replace dx = lx*qx if  Age==4 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 5 & cstr==`i'
		 replace dx = lx*qx if  Age==5 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 6 & cstr==`i'
		 replace dx = lx*qx if  Age==6 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 7 & cstr==`i'
		 replace dx = lx*qx if  Age==7 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 8 & cstr==`i'
		 replace dx = lx*qx if  Age==8 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 9 & cstr==`i'
		 replace dx = lx*qx if  Age==9 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 10 & cstr==`i'
		 replace dx = lx*qx if  Age==10 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 11 & cstr==`i'
		 replace dx = lx*qx if  Age==11 & cstr==`i'
     	 replace lx = lx[_n-1] - dx[_n-1] if  Age== 12 & cstr==`i'
		 replace dx = lx*qx if  Age==12 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 13 & cstr==`i'
		 replace dx = lx*qx if  Age==13 & cstr==`i'
         replace lx = lx[_n-1] - dx[_n-1] if  Age== 14 & cstr==`i'
		 replace dx = lx*qx if  Age==14 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 15 & cstr==`i'
		 replace dx = lx*qx if  Age==15 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 16 & cstr==`i'
		 replace dx = lx*qx if  Age==16 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 17 & cstr==`i'
		 replace dx = lx*qx if  Age==17 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 18 & cstr==`i'
		 replace dx = lx*qx if  Age==18 & cstr==`i'
		 replace lx = lx[_n-1] - dx[_n-1] if  Age== 19 & cstr==`i'
		 display "Number of records updated: `i'"
}

sort cstr qsdi Age n
  forval i = 1(1)35959 {
	     replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 1 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 2 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 3 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 4 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 5 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 6 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 7 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 8 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 9 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 10 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 11 & cstr==`i'
     	 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 12 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 13 & cstr==`i'
         replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 14 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 15 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 16 & cstr==`i'
		 replace Lx = 5 * (lx + lx[_n+1])/2  if  Age== 17 & cstr==`i'
		 replace Lx = 10 * (lx + lx[_n+1])/2  if  Age== 18 & cstr==`i'
		 replace Lx = . if Age == 19
		 display "Number of records updated: `i'"
}

sort cstr qsdi Age n
  forval i = 1(1)35959 {
	     gsort -Age
         replace Tx = sum(Lx) if cstr==`i'
		 display "Number of records updated: `i'"
}

replace Ex = (Tx/lx) 
drop if Age == 19
drop Age 
sort cstr qsdi age n
duplicates list sc n, force 

// Figure LE at birth males
reg Ex ib1.qsdi if n==1
margins qsdi
marginsplot

reg Ex ibn.age, nocons
margins age

save fablifetable, replace

// Life Table to be shared
//gen Age = age
//lab def Age 2  "0-4" 7  "5-9" 12 "10-14" 17 "15-19" 22 "20-24" 27  "25-29" 32 "30-34" 37 "35-39" 42 "40-44" ///
//47 "45-49" 52 "50-54" 57 "55-59" 62 "60-64" 67 "65-69" 72 "70-74" 77 "75-79" 82 "80-84" 87 "85+", replace
//lab val Age Age
//drop cmr death Pop cstr 
//decode Age, gen(Agegroup)
//rename sc Areacode
//rename qsdi Deprivation
//drop Age
//order Areacode Deprivation Agegroup
//sort Areacode n Deprivation
export delimited using "/Users/MALF/Dropbox/EASP/FIS2018/Articles/3_THIRD_LIFETABLES/Analysis/fablifetable.csv", replace

