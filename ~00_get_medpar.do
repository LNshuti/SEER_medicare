capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "00_get_medpar", t replace
local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare clean up
* Eric Chow, 06-06-2018
*
* appends the medpar files that contains claims.
* these files were obtained by running the SAS scripts provided by medicare
* destring, and subsets the population
* ------------------------------------------------------------------------------

set more off

clear 
clear mata
clear matrix
set maxvar 10000 

* ---------------------------------
* this program opens the pedsf file
* selects vars, destrings them and
* saves to a smaller dta.

capture program drop clean_medpar
program define clean_medpar
	args filepath
	
	use "`filepath'"

	keep    patient_id age mdcrstat stdstate snfind ///
			adm_m adm_d adm_y   dis_m dis_d dis_y los  ///
			totchrgs cvrdchrg reimbamt drgprice ///
			raddgind radthind nucmdind ctscnind oimsrind  ///
			numdxcde dgn_cd* surgind numsrgcd numsrgdt srgcde* sg_dt* ///
			drgcode discdest 

	quietly destring age mdcrstat stdstate  ///
			adm_m adm_d adm_y   dis_m dis_d dis_y   ///
			raddgind radthind nucmdind ctscnind oimsrind  ///
			numdxcde surgind numsrgcd numsrgdt srgcde* sg_dt* ///
			drgcode discdest , replace force
	 
	saveold "`filepath'_small", v(12) replace
end



* -------------------------------------------------------
* clean the files

clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar00"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar01"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar02"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar03"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar04"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar05"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar06"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar07"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar08"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar09"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar10"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar11"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar12"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar13"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar14"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar91"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar92"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar93"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar94"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar95"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar96"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar97"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar98"
clean_medpar "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar99"

* -------------------------------------------------------
* append the 6 files

use "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar00_small", clear
gen file = 0
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar01_small"
replace file = 1 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar02_small"
replace file = 2 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar03_small"
replace file = 3 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar04_small"
replace file = 4 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar05_small"
replace file = 5 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar06_small"
replace file = 6 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar07_small"
replace file = 7 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar08_small"
replace file = 8 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar09_small"
replace file = 9 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar10_small"
replace file = 10 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar11_small"
replace file = 11 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar12_small"
replace file = 12 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar13_small"
replace file = 13 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar14_small"
replace file = 14 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar91_small"
replace file = 91 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar92_small"
replace file = 92 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar93_small"
replace file = 93 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar94_small"
replace file = 94 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar95_small"
replace file = 95 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar96_small"
replace file = 96 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar97_small"
replace file = 97 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar98_small"
replace file = 98 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar99_small"
replace file = 99 if missing(file)



saveold "/Volumes/QSU/Datasets/SEER_medicare/medpar/medpar_small", v(12) replace


log close
*         ~ fin ~
