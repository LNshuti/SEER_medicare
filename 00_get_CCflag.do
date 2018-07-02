capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "00_get_CCflag", t replace
local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare clean up
* Eric Chow, 04-27-2017
*
* appends the 6 pedsf files that list all the cancer cases (cancer dgn file)
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

capture program drop clean_CCflag
program define clean_CCflag
	args filepath
	
	use "`filepath'"
	keep * 
	compress
	saveold "`filepath'_small", v(12) replace
end



* -------------------------------------------------------
* open 16 files!

clean_CCflag "~/QSU/SEER-medicare/data/CCflag00"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag01"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag02"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag03"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag04"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag05"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag06"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag07"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag08"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag09"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag10"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag11"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag12"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag13"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag14"
clean_CCflag "~/QSU/SEER-medicare/data/CCflag99"


* -------------------------------------------------------
* append the 6 files

use "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag00_small", clear
gen file = 0
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag01_small"
replace file = 1 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag02_small"
replace file = 2 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag03_small"
replace file = 3 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag04_small"
replace file = 4 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag05_small"
replace file = 5 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag06_small"
replace file = 6 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag07_small"
replace file = 7 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag08_small"
replace file = 8 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag09_small"
replace file = 9 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag10_small"
replace file = 10 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag11_small"
replace file = 11 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag12_small"
replace file = 12 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag13_small"
replace file = 13 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag14_small"
replace file = 14 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag99_small"
replace file = 99 if missing(file)



saveold "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag_small", v(12) replace


log close
*         ~ fin ~
