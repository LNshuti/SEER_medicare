cd "~/QSU/SEER-medicare/ICD_9_CM_procedure"

* 87 
insheet using "ICD_9_CM_87_diagnostic_radiology.csv", clear
saveold "ICD_9_CM_87_diagnostic_radiology", replace

* 88
insheet using "ICD_9_CM_88_other_diag_rad_related_technq.csv", clear
saveold "ICD_9_CM_88_other_diag_rad_related_technq", replace

* 92
insheet using "ICD_9_CM_92_nuc_medicine.csv", clear
saveold "ICD_9_CM_92_nuc_medicine", replace

* parent
insheet using "ICD_9_CM_parents.csv", clear
saveold "ICD_9_CM_parents", replace

* -------------------
* open and append

use "ICD_9_CM_87_diagnostic_radiology", clear
append using "ICD_9_CM_88_other_diag_rad_related_technq"
append using "ICD_9_CM_92_nuc_medicine"

merge m:1 parent using "ICD_9_CM_parents"
drop _merge

rename desc_parent category
drop parent

label var prcdr_cd "SEER-medicare outsaf.txt procedure code"

saveold "ICD_9_CM_procedures", replace
