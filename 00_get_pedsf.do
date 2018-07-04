capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "00_get_pedsf", t replace
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

capture program drop clean_pedsf
program define clean_pedsf
	args filepath
	
	use "`filepath'"

	keep oshufcase patient_id mat_type ///
		 med_dodm med_dodd med_dody   ///
		 birthm birthyr yr_brth s_sex race rac_rec* srace agedx* ///
		 state county urbrur urban ///
		 med_stcd medst_yr icd_code cod10v cod89v /// 
		 count resnrec marst* nosrg* rad* radbrn* radsurg* sssurg* sxscop* sxsite* ///
		 reg* seq* modx* yrdx* site* gho* mon* lat* hist* histrec* ///
		 beh* grade* dxconf* src* e10* cstum* ///
		 typefu* ///
		 hstst* ajccstg* aj3sr* frstprm* summ2k* vsrtdx* intprim* ///
		 srvm* monrx* yearrx* 
	 
	encode mat_type, gen(mat_type_)
	drop mat_type

	quietly destring  s_sex race med_stcd medst_yr ///
	 srace count resnrec ///
	 state county urbrur urban ///
	 rac_rec* icd_code cod* registry* reg2cd* reg* /// 
	marst* agedx* seq*  site* sssurg* sxscop* sxsite* ///
	lat* hist* beh* hist* grade* dxconf* src* e10* cstum* nosrg* rad* typefu*  ///
	aj3sr* hstst* ajccstg* frstprm* summ2k* vsrtdx* intprim* srvm* monrx* yearrx* , replace
	 
	saveold "`filepath'_small", v(12) replace
end



* -------------------------------------------------------
* open 6 files!

clean_pedsf "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_01"
clean_pedsf "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_02"
clean_pedsf "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_03"
clean_pedsf "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_04"
clean_pedsf "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_05"
clean_pedsf "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_06"


* -------------------------------------------------------
* append the 6 files

use "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_01_small", clear
gen file = 1
append using "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_02_small"
replace file = 2 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_03_small"
replace file = 3 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_04_small"
replace file = 4 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_05_small"
replace file = 5 if missing(file)
append using "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_06_small"
replace file = 6 if missing(file)


saveold "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_small", v(12) replace


log close
*         ~ fin ~
