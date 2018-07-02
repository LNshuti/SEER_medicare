capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "10_merge", t replace
local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare clean up
* Eric Chow, 04-27-2017
*
* appends the 6 pedsf files that list all the cancer cases (cancer dgn file)
* these files were obtained by running the SAS scripts provided by medicare
* destring, and subsets the population.
*
* do the rhings from Baiyu's file. ie: 
*    1. get only those w firdt dx == lung cancer, not just any dx of LC (use SITERWHO, seq1=00|01)
*    2. keep if dgn in 2000-2013
*    3. must be enerolled in medicar part A & B, & not in HMO in mnth of dgn
*    4. keep only dgn from 2000-2013 - compare w SEER*medicare website
* ------------------------------------------------------------------------------

set more off

clear 
clear mata
clear matrix
set maxvar 10000 

use "/Volumes/QSU/Datasets/SEER_medicare/data/pedsf_analysis_long", clear

* how many first, second, third, and fourth lung cancers are there?
tab seq_lc

* how many second lung cancers occur 5+ years after the first lung cancer?
gen diag_dt2 = diag_dt if seq_lc == 2
egen diag_dt2_ = min(diag_dt2), by(patient_id)
gen t_2nd_lc = diag_dt2_ - diag_dt if seq_lc == 1
label var t_2nd_lc "days from first LC to second LC"
// drop diag_dt2 diag_dt2_
codebook t_2nd_lc

* if 2nd LC occured 5+ years afte 1st, flag
capture drop t_2nd_lc_flag
gen t_2nd_lc_flag = (t_2nd_lc > 365.24*5)
replace t_2nd_lc_flag = . if  missing(t_2nd_lc)

* how many of the 2nd lung cancers occurr 5+ years after?
codebook t_2nd_lc_flag



//      ~ fin ~
