cd "~/Desktop/SEER_medicare"

use "outsaf00.file001_patientids.dta", clear
destring patient_id, replace
count

preserve
	insheet using "patient_ids.csv", clear
	saveold patient_ids.dta, replace
restore

merge 1:1 patient_id using patient_ids
drop if _merge == 2

tab _merge

// should only be 13,764 (18,195 unique IDs)
