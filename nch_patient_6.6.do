capture log close
clear

cd "~/QSU/"
log using "nch_patient_6.6", t replace
local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare merge nch to study popluation
* Eric Chow, 09-11-2018
* why does 6% of participants not have claims?
* ------------------------------------------------------------------------------

set more off

clear 
clear mata
clear matrix
set maxvar 10000 

// open the huge file in Stata
use "/Users/echow/DATA_SEER_medicare/small_nch_APPENDED_1yr.dta", clear
use "/Volumes/QSU/Datasets/SEER_medicare/nch/small_nch_APPENDED_1yr.dta", clear
count // 
keep patient_id
duplicates drop
gen nch_claims = 1

// merge in the study population (splc.dta) using char patient_id - bring in race also as the flag
merge m:1 patient_id using "/Users/echow/DATA_SEER_medicare/splc.dta"
merge m:1 patient_id using "/Volumes/QSU/Datasets/SEER_medicare/data/splc.dta"
// code records with no claims
replace nch_claims = 0 if missing(nch_claims)

// is it the diagnosis date?
hist diag_dt1 if nch_claims == 1
hist diag_dt1 if nch_claims == 0

// is it the death dt date?
hist med_death_dt if nch_claims == 1
hist med_death_dt if nch_claims == 0

tab death_lc nch_claims

hist agedx1 if nch_claims == 1
hist agedx1 if nch_claims == 0

gen exposure = med_death_dt - diag_dt1

codebook exposure if nch_claims == 1
codebook exposure if nch_claims == 0






log close
*         ~ fin ~
