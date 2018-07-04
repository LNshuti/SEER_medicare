capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "02_create_dataset", t replace
local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare clean up
* Eric Chow, 04-27-2017
*
* opens pedsf_small.dta which appended the 6 files, and kept only some vars
* but no other data transformations done (some string to text)
*
* do the Things from Baiyu's file. ie: 
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

* sort by patient id, diag_dt, and histology
sort patient_id diag_dt hist2_

* reshape to wide format
reshape wide  diag_dt hist2_ histbeh histrec seq agedx reg  e10* dx_i med_stcd medst_yr marst modx_ yrdx_ site lat  beh2_ hist beh grade dxconf src cstum nosrg rad radbrn radsurg sssurg sxscop sxsite typefu siterwho behtrend hstst ajccstg aj3sr frstprm summ2k vsrtdx intprim srvm srvmflag yearrx, i(patient_id) j(seq_lc)
isid patient_id
order patient_id diag_dt* agedx* hist2_* histrec* hist*

* group histology categories based on hist + beh (morphology from ICD-O-3 of histology and beh)
tab histbeh1
capture drop hist_cat1
gen hist_cat1 = ""
replace hist_cat1 = "AD" if inlist(hist1, 8140, 8141, 8143)
replace hist_cat1 = "SQ" if inrange(hist1, 8070, 8076)
replace hist_cat1 = "SC" if inrange(hist1, 8041, 8045)
replace hist_cat1 = "LC" if inrange(hist1, 8012, 8014)
replace hist_cat1 = "BAC" if inrange(hist1, 8250, 8255)
replace hist_cat1 = "CARCINOID" if inlist(hist1, 8240)
replace hist_cat1 = "CARCINOMA, NOS" if inlist(hist1,8010,8011, 8015)
replace hist_cat1 = "neoplasm, malignant" if inlist(hist1, 8000)
replace hist_cat1 = "nSC" if inlist(hist1, 8046)
replace hist_cat1 = "OTH" if hist_cat1 == ""
tab hist_cat1

// label define hist_cat 0 "unspecified neoplasms" 1 "epithelial neoplasms, NOS" 2 "squamous cell neoplasms" 3 "adenomoas/adenocarcinomas" 99 "other"
// label values hist_cat hist_cat

* define aj3sr
label define aj3sr 0 "in situ" 10 "I" 11 "IA" 12 "IB" 13 "IC" 19 "I, NOS" 20 "II" 21 "IIA" 22 "IIB" 23 "IIC" 29 "II, NOS" 30 "III" 31 "IIIA" 32 "IIIB" 33 "IIIC" 39 "III, NOS" 40 "IV" 41 "IVA" 42 "IVB" 49 "IV, NOS" 90 "unstaged" 98 "na"
label values aj3sr1 aj3sr

* define grade
label define grade 1 "grade I" 2 "grade II" 3 "grade III" 4 "grade IV" 5 "T-cell" 6 "B-cell" 7 "Null cell" 8 "NK cell" 9 "cell type not determined"
label values grade1 grade

* define laterality
label define lat 0 "not paired site" 1 "right" 2 "left" 3 "only one side involved, R/L unspecified" 4 "bilateral involvement" 5 "paired site, midline" 9 "paired site, but no laterality info"
label values lat1 lat

* relabel vars
label var agedx1 "Age at index LC"
label var frstprm1 "First primary malignant"
label var hist_cat "histology"
label var histrec1 "histology"
label var lat1 "laterality" 
label var yrdx_1 "year of diagnosis"
label var aj3sr1 "SEER modified AJCC stage 3ed"
label var grade1 "Grade"
label var e10sz1 "Tumor size"
label var e10ex1 "Extension"
label var e10pe1 "Extension prostate path"
label var e10nd1 "Lymph node involvement"
label var e10ne1 "Regional nodes examined"
label var e10pn1 "Regional nodes positive"


* show those w multiple dgn at top
sort diag_dt4 diag_dt3 diag_dt2

* ----------------------------------------
* ascertain 2nd PLC:
* if hist2 is different from hist 1, it's 2PLC
* else: (hist 2 is same)
*    if diag_dt2 > 2yrs, it's 2PLC
*    else: (hist2 same, diag_dt2 too soon)
*         if hist3 different from hist1, it's 2PLC
*         else (hist3 is same)
*              if diag_dt3 > 2yrs, it's 2PLC
*              else: (hist3 same & diag3 too soon)
*                    if hist4 different from hist1, it's 2PLC
*					 else (hist4 is same)
// 					      if diag_dt4 > 2hrs, it's 2PLC
// 						  else: hist4 same, & diag_dt4 too soon - not 2PLC

* the date of SPLC
capture drop splc_dt
gen splc_dt = .
label var splc_dt "2nd primary lung cancer if histology result differs from index tumor, or if same, if dgn > 2yrs after"
format %td splc_dt

* ------------------------------------------------------------------
* merge in the chronic conditions now, by patient ID and year of dgn
* takes a while to merge *****8
gen bene_enrollmt_ref_yr = yrdx_1
merge m:1 patient_id bene_enrollmt_ref_yr using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag_small.dta"

drop if _merge == 2
drop _merge
drop bene_enrollmt_ref_yr


order patient_id splc_dt
* ------------------------------------------------------------------------------
* if hist2 is different from hist1, it's 2PLC
replace splc_dt = diag_dt2       if hist2 != hist1 & !missing(diag_dt2)
* if hist2 == hist1, but it's 2yrs later, it's 2PLC
replace splc_dt = diag_dt2       if hist2 == hist1 & diag_dt2 >= diag_dt1+365*2 & !missing(diag_dt2)
* if 2PLC not found in diag_dt2, look in diag_dt3
replace splc_dt = diag_dt3       if hist3 != hist1 & !missing(diag_dt3) & missing(splc_dt)
replace splc_dt = diag_dt3       if hist3 == hist1 & diag_dt3 >= diag_dt1+365*2 & !missing(diag_dt3) & missing(splc_dt)
* if 2PLC not found in diag_dt3, look in diag_dt4
replace splc_dt = diag_dt4       if hist4 != hist1 & !missing(diag_dt4) & missing(splc_dt)
replace splc_dt = diag_dt4       if hist4 == hist1 & diag_dt4 >= diag_dt1+365*2 & !missing(diag_dt4) & missing(splc_dt)

capture drop splc_flg
gen splc_flg = 0
replace splc_flg = 1 if !missing(splc_dt)
tab splc_flg


* merge in FIPS codes

* figure otu treatments from pedsf

* age categories for table 1

* use comorbs from Summer paper



* ------------------------------------------------------------------------------
* save an analytical cohort
saveold "/Volumes/QSU/Datasets/SEER_medicare/data/splc", v(12) replace

* table 1
table1, vars(agedx1		conts \     ///
			 race		cat \ 		///
			 s_sex 		cat	\		///
			 frstprm1   cat \       ///
			 hist_cat   cat \       ///
			 aj3sr1     cat \       ///
			 grade1		cat \       ///
			 site1      cat \       ///
			 lat1       cat \       ///
			 yrdx_1     cat \       ///
			 e10ex1     conts \     ///
			 e10nd1     conts \     ///
			 e10sz1     conts \     ///
			 e10pn1     conts \     ///
			 e10ne1     conts \     ///
			 urban      cat \       ///
			 alzh       cat \       ///
			 ami        cat \       ///
			 anemia     cat \       ///
			 asthma     cat \       ///
			 atrial_fib cat \       ///
			 chf        cat \       ///
			 chronickidney cat \       ///
			 copd       cat \       ///
			 diabetes   cat \       ///
			 hyperl     cat \       ///
			 hypert     cat \       ///
			 hypoth     cat \       ///
			 ischemicheart cat \       ///
			 osteoporosis cat \       ///
			 stroke_tia   cat \       ///
			 ) by(splc_flg) format(%2.1f)

* 2018-06-26 TODO **********************
****************************************

* [ ] go from long on lung cancer sequence to wide, so that each of LC 1...4 has it's own set of cols
* [ ] ascertain outcome (2PLC - if subsequent LC is different histology or, if same histology, is atleast 2years after 1PLC
* [ ] 
