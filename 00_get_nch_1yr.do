capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "00_get_nch_1yr", t replace
local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare clean up
* Eric Chow, 04-27-2017
*
* opens all the 700 outsaf files and appends them
* ------------------------------------------------------------------------------

set more off

clear 
clear mata
clear matrix
set maxvar 10000 



* SEP 11 - RUN FROM HERE! to end of file. FOR KRISTEN. do it for Kristen.
* need to copy down the small_nch00-nch99 and splc.dta files *****


* ------------------------------------------------------------------------------
* Takes small files 00...99 (already n=271,892 and subsets to claims within 1year of diagnosis date

* get a list of small nch files 
local nch_sm_files: dir "~/DATA_SEER_medicare/small_nch00-nch99" files "small_nch*"	 // upper case
local i = 1

* merge to only 271892 patients, and  save out 700 dta files (HCPCS AND DGN)
foreach file of local nch_sm_files {
	
	di "`i'     `file'"
	use "~/DATA_SEER_medicare/small_nch00-nch99/`file'", clear

	// merge in the study population (splc.dta) using char patient_id - bring in race also as the flag
	* MERGE IN THE 271892 popluation ---------------------------------------
	quietly merge m:1 patient_id using "~/DATA_SEER_medicare/splc.dta", keepusing(diag_dt1)
	drop if _merge == 2 // drop any right-joined patient_ids without any nch claims
	keep if thru_dt >= diag_dt1 & from_dt <= diag_dt1+365
	drop _merge // don't need this variable anymore
	
	* ----------------------------------------------------------------------

	* save as one file
	saveold "~/DATA_SEER_medicare/small_nch00-nch99_1yr/`file'_1yr.dta", v(12) replace
	
	local i = `i' + 1  // increment i
}











		
		


* ------------------------------------------------------------------------------
* append files for HCPCS the 972 files

* get a list of small nch files 
local nch_sm_files: dir "/Users/echow/DATA_SEER_medicare/small_nch00-nch99_1yr" files "small_nch*"	 // upper case
local i = 1

* compress and save out 700 dta files (HCPCS AND DGN)
foreach file of local nch_sm_files {
	if (`i' == 1) { // first file isn't necessarily file001... 
	di "`i'     `file'"
		use "/Users/echow/DATA_SEER_medicare/small_nch00-nch99_1yr/`file'", clear
		// drop dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 
		gen file = 1
	}
	if (`i' > 1)  {
 		di "`i'     `file'"
		append using "/Users/echow/DATA_SEER_medicare/small_nch00-nch99_1yr/`file'", keep(patient_id claim_id from_dt thru_dt state_cd ms_cd clm_type rfr_upin rfr_npi hcfaspec hcpcs mf1 mf2 mf3 mf4 dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 lsubmamt lalowamt srvc_cnt linediag linepmt pmt_amt hcpcs_yr prv_type clinecnt cdgncnt year rec_count)
		replace file = `i' if missing(file)
	}
	local i = `i' + 1  // increment i
}
// compress
* save as one file
saveold "/Users/echow/DATA_SEER_medicare/small_nch_APPENDED_1yr", v(12) replace


// * ------------------------------------------------------------------------------
// * append files for diagnosis codes the 972 files
// * does not include HCPCS codes, those are in a seperate file b/c too big
// * patient_id and claim_id should be the 

// * look for small nch files 
// local nch_sm_files: dir "/Users/echow/DATA_SEER_medicare" files "small_nch*file*"	 // upper case
// local i = 1

// * compress and save out 700 dta files
// foreach file of local nch_sm_files {
// 	if (`i' == 1) { // first file isn't necessarily file001... 
// 		use "/Users/echow/DATA_SEER_medicare/`file'", clear
// 		keep patient_id claim_id dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 
// 		gen file = 1
// 	}
// 	if (`i' > 1)  {
//  		di "`i'     `file'"
// 		append using "/Users/echow/DATA_SEER_medicare/`file'", keep(patient_id claim_id dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12)
// 		replace file = `i' if missing(file)
// 	}
// 	local i = `i' + 1  // increment i
// }

// compress
// * save as one file
// saveold "/Users/echow/DATA_SEER_medicare/small_nch_dgn_APPENDED", v(12) replace




log close
*         ~ fin ~
