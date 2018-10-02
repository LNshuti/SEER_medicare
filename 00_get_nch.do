capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "00_get_nch", t replace
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

* ---------------------------------
* this program opens the pedsf file
* selects vars, destrings them and
* saves to a smaller dta.

capture program drop clean_nch
program define clean_nch
	args file
	
	use "/Users/echow/DATA_SEER_medicare/`file'"
	
	keep  patient_id claim_id state_cd ms_cd clm_type ///
	from_dtm from_dtd from_dty thru_dtm thru_dtd thru_dty ///
	rfr_upin rfr_npi hcfaspec ///
	hcpcs mf1 mf2 mf3 mf4 lsubmamt lalowamt srvc_cnt linediag linepmt pmt_amt ///
	hcpcs_yr prv_type clinecnt cdgncnt  ///
	dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 ///
	year rec_count

	 	 
	destring  state_cd ms_cd clm_type ///
	hcfaspec linediag hcpcs_yr prv_type clinecnt cdgncnt year rec_count, replace force
	
	* drop because of SAS outer merge
	drop if missing(claim_id)
		 
		 
		 
	* clean up the dates	
	gen from_dt_ = from_dtm + "-" + from_dtd + "-" + from_dty
	gen from_dt = date(from_dt_, "MDY")
	format %td from_dt
	drop from_dt_ from_dtm from_dtd from_dty
	
	gen thru_dt_ = thru_dtm + "-" + thru_dtd + "-" + thru_dty
	gen thru_dt = date(thru_dt_, "MDY")
	format %td thru_dt
	drop thru_dt_ thru_dtm thru_dtd thru_dty
		
	
	compress 
	saveold "/Users/echow/DATA_SEER_medicare/small_`file'", v(12) replace
end



* -------------------------------------------------------
* clean and compress 700 files

* test one file
if (1==0) {
	clean_outsaf "nch00.file001.txt.dta"
}

* look for outpat files
local nch_files: dir "/Users/echow/DATA_SEER_medicare" files "nch*"	 // upper case

* compress and save out 700 dta files
foreach file of local nch_files {
	clean_nch "`file'"
}















* ------------------------------------------------------------------------------
* RUN THIS SECOND
* append files for HCPCS the 972 files
* does not include dgn codes, those are in a seperate file b/c too big

* look for small nch files 
local nch_sm_files: dir "/Users/echow/DATA_SEER_medicare" files "small_nch*"	 // upper case
local i = 1

* compress and save out 700 dta files
foreach file of local nch_sm_files {
	if (`i' == 1) { // first file isn't necessarily file001... 
		use "/Users/echow/DATA_SEER_medicare/`file'", clear
		drop dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 
		gen file = 1
	}
	if (`i' > 1)  {
 		di "`i'     `file'"
		append using "/Users/echow/DATA_SEER_medicare/`file'", keep(patient_id claim_id from_dt thru_dt state_cd ms_cd clm_type rfr_upin rfr_npi hcfaspec hcpcs mf1 mf2 mf3 mf4 lsubmamt lalowamt srvc_cnt linediag linepmt pmt_amt hcpcs_yr prv_type clinecnt cdgncnt year rec_count)
		replace file = `i' if missing(file)
	}
	local i = `i' + 1  // increment i
}
compress
* save as one file
saveold "/Users/echow/DATA_SEER_medicare/small_nch_HPCPS_APPENDED", v(12) replace




* ------------------------------------------------------------------------------
* append files for diagnosis codes the 972 files
* does not include HCPCS codes, those are in a seperate file b/c too big
* patient_id and claim_id should be the 

* look for small nch files 
local nch_sm_files: dir "/Users/echow/DATA_SEER_medicare" files "small_nch*file*"	 // upper case
local i = 1

* compress and save out 700 dta files
foreach file of local nch_sm_files {
	if (`i' == 1) { // first file isn't necessarily file001... 
		use "/Users/echow/DATA_SEER_medicare/`file'", clear
		keep patient_id claim_id dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 
		gen file = 1
	}
	if (`i' > 1)  {
 		di "`i'     `file'"
		append using "/Users/echow/DATA_SEER_medicare/`file'", keep(patient_id claim_id dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12)
		replace file = `i' if missing(file)
	}
	local i = `i' + 1  // increment i
}

compress
* save as one file
saveold "/Users/echow/DATA_SEER_medicare/small_nch_dgn_APPENDED", v(12) replace







log close
*         ~ fin ~
