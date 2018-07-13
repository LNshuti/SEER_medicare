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
* how many LC diagnoses were there?
count
* compare the yearly number of cases to SEER-Medicare website
* https://healthcaredelivery.cancer.gov/seermedicare/aboutdata/cases.html
tab yrdx if inlist(seq, 0, 1)
// year      SEER     N (this data)
// 2013     14,869    14,856
// 2012     15,620    15,620
// 2011     15,636    15,630
// 2010     16,161    16,164
// 2009     16,733    16,727
// 2008     17,210    17,206
// 2007     17,516    17,511
// 2006     18,085    18,081
// 2005     18,631    18,624
// 2004     18,755    18,747
// 2003     18,880    18,879
// 2002     18,369    18,359
// 2001     17,769    17,761
// 2000     17,083    17,076



* sort by patient id, diag_dt, and histology
sort patient_id diag_dt hist2_

* -------------------------
* reshape to wide format
reshape wide  diag_dt hist2_ histbeh histrec seq agedx reg  e10* dx_i med_stcd medst_yr marst modx_ yrdx_ site lat  beh2_ hist beh grade dxconf src cstum nosrg rad radbrn radsurg sssurg sxscop sxsite typefu siterwho behtrend hstst ajccstg aj3sr frstprm summ2k vsrtdx intprim srvm srvmflag yearrx, i(patient_id) j(seq_lc)
isid patient_id
order patient_id diag_dt* agedx* hist2_* histrec* hist*
* how many patients are there?
count

* show those w multiple dgn at top
sort diag_dt4 diag_dt3 diag_dt2

* group histology categories based on hist + beh (morphology from ICD-O-3 of histology and beh)
forval i = 1/4 {
	tab histbeh`i'
	capture drop hist_cat`i'
	gen hist_cat`i' = ""
	replace hist_cat`i' = "AD" if inlist(hist`i', 8140, 8141, 8143)
	replace hist_cat`i' = "SQ" if inrange(hist`i', 8070, 8076)
	replace hist_cat`i' = "SC" if inrange(hist`i', 8041, 8045)
	replace hist_cat`i' = "LC" if inrange(hist`i', 8012, 8014)
	replace hist_cat`i' = "BAC" if inrange(hist`i', 8250, 8255)
	replace hist_cat`i' = "CARCINOID" if inlist(hist`i', 8240)
	replace hist_cat`i' = "CARCINOMA, NOS" if inlist(hist`i',8010,8011, 8015)
	// replace hist_cat`i' = "neoplasm, malignant" if inlist(hist`i', 8000)         categorize as other
	// replace hist_cat`i' = "nSC" if inlist(hist`i', 8046)							categorize as other
	replace hist_cat`i' = "OTH" if hist_cat`i' == ""
	tab hist_cat`i'
	encode hist_cat`i', gen(hist_cat`i'_)
	drop hist_cat`i' 
	rename hist_cat`i'_ hist_cat`i'
}




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
label var hist_cat1 "histology at index LC"
label var hist_cat2 "histology at 2nd LC"
label var hist_cat3 "histology at 3rd LC"
label var hist_cat4 "histology at 4th LC"
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



* ------------------------------------------------------------------
* merge in the chronic conditions now, by patient ID and year of dgn
* takes a while to merge *****
*
* COMORBIDITIES: (Dutkowska, Antczak 2016)
* COPD, Pneumonia, Silicosis, Residual TB
* hypertension, coronary artery disease, 
* peripheral vascular disease, arrhythmia, 
* abdominal aortic aneurysm,
* ischemic heart disease, cerebrovascular disease
* chronic obstructive pulmonary disease (COPD)
* diabetes mellitus (DM)

gen bene_enrollmt_ref_yr = yrdx_1
merge m:1 patient_id bene_enrollmt_ref_yr using "/Volumes/QSU/Datasets/SEER_medicare/CCflag/CCflag_small.dta", ///
	keepusing(ami asthma atrial_fib chf copd diabetes hypert ischemicheart stroke_tia)

drop if _merge == 2
drop _merge
drop bene_enrollmt_ref_yr

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


order patient_id splc_dt
* ------------------------------------------------------------------------------
* if hist_cat2 is different from hist_cat1, it's 2PLC 
replace splc_dt = diag_dt2       if hist_cat2 != hist_cat1 & !missing(diag_dt2)
* if hist2 == hist1, but it's 2yrs later, it's 2PLC
replace splc_dt = diag_dt2       if hist_cat2 == hist_cat1 & diag_dt2 >= diag_dt1+365*2 & !missing(diag_dt2)
* if 2PLC not found in diag_dt2, look in diag_dt3
replace splc_dt = diag_dt3       if hist_cat3 != hist_cat1 & !missing(diag_dt3) & missing(splc_dt)
replace splc_dt = diag_dt3       if hist_cat3 == hist_cat1 & diag_dt3 >= diag_dt1+365*2 & !missing(diag_dt3) & missing(splc_dt)
* if 2PLC not found in diag_dt3, look in diag_dt4
replace splc_dt = diag_dt4       if hist_cat4 != hist_cat1 & !missing(diag_dt4) & missing(splc_dt)
replace splc_dt = diag_dt4       if hist_cat4 == hist_cat1 & diag_dt4 >= diag_dt1+365*2 & !missing(diag_dt4) & missing(splc_dt)

* merge in FIPS codes of state
rename state fips
merge m:1 fips using "/Users/echow/QSU/SEER-medicare/data/state_fips.dta", keepusing(state)
drop if _merge == 2
drop _merge

* encode state
encode state, gen(state_)
drop state
rename state_ state
tab state


* define treatment *

* label radsurg
label var radsurg1 "for patients who had BOTH surgery and radiation, the order of surgery/radiation"
label define radsurg 0 "No radiation and/or surgery as defined above" 2 "Radiation before surgery" 3 "Radiation after surgery" 4 "Radiation both before and after surgery" 5 "Intraoperative radiation therapy" 6 "Intraoperative radiation with other radiation given before or after surgery" 9 "Sequence unknown, but both surgery and radiation were given"
label values radsurg1 radsurg
// 0 No radiation and/or surgery as defined above
// 2 Radiation before surgery
// 3 Radiation after surgery
// 4 Radiation both before and after surgery
// 5 Intraoperative radiation therapy
// 6 Intraoperative radiation with other radiation
// given before or after surgery
// 9 Sequence unknown, but both surgery and
// radiation were given

* label no surg
label var nosrg1 "reason that surgery not performed on primary site"
label define surg 0 "Surgery performed" 1 "Surgery not recommended" 2 "Contraindicated due to other conditions; Autopsy Only case" 5 "Patient died before recommended surgery" 6 "Unknown reason for no surgery" 7 "Patient or patient's guardian refused" 8 "Recommended, unknown if done" 9 "Unknown if surgery performed; Death Certificate Only case" 
label values nosrg1 surg
// 0 Surgery performed
// 1 Surgery not recommended
// 2 Contraindicated due to other conditions; Autopsy Only case
// 5 Patient died before recommended surgery
// 6 Unknown reason for no surgery
// 7 Patient or patient's guardian refused
// 8 Recommended, unknown if done
// 9 Unknown if surgery performed; Death Certificate Only case

* label rad
label var rad1 "method of radiation therapy performed as part of the first course of treatment"
label define rad 0 "None; diagnosed at autopsy" 1 "Beam radiation" 2 "Radioactive implants" 3 "Radioisotopes" 4 "Combination of 1 with 2 or 3" 5 "Radiation, NOS – method or source not specified" 6 "Other radiation (1973-1987 cases only)" 7 "Patient or patient’s guardian refused radiation therapy" 8 "Radiation recommended, unknown if administered" 9 "Unknown if radiation administered" 
label values rad1 rad
// 0 None; diagnosed at autopsy
// 1 Beam radiation
// 2 Radioactive implants
// 3 Radioisotopes
// 4 Combination of 1 with 2 or 3
// 5 Radiation, NOS – method or source not specified
// 6 Other radiation (1973-1987 cases only)
// 7 Patient or patient’s guardian refused radiation therapy
// 8 Radiation recommended, unknown if administered
// 9 Unknown if radiation administered

* ----------------------------------------------
* assign treatment categories
* ----------------------------------------------
capture drop init_tx1
gen init_tx1 = "n/a"
label var init_tx1 "composite of nosrg, rad, and radsurg"

replace init_tx1 = "surg only" if nosrg1 == 0 & inlist(rad1,0,7)
replace init_tx1 = "rad only"  if inlist(rad1,1,2,3,4,5,6) & !(inlist(nosrg1,  0,8,9))
replace init_tx1 = "surg, then rad"  if radsurg1 == 3
replace init_tx1 = "other surg+rad comb" if inlist(radsurg1, 2, 4, 5, 6)
replace init_tx1 = "no surg or rad" if inlist(nosrg1, 1,2,5,6,7) & inlist(rad1, 0, 7) //& init_tx1 == "n/a"
replace init_tx1 = "pt refused rad or surg" if nosrg1 == 7 & rad1 == 7
replace init_tx1 = "unknown if surg or rad done" if inlist(nosrg1, 8, 9) & inlist(rad1, 8, 9)
* look at crosstab
tab init_tx1

* look at cases yet unclassified
tab nosrg1 rad1 if init_tx1 == "n/a"
* fix odd cases
replace init_tx1 = "other surg+rad comb" if inlist(nosrg1, 0) & inlist(rad1, 1,2,3,4,5) & init_tx1 == "n/a"
* assume unknown if unknown surgery, and no rad
replace init_tx1 = "unknown if surg or rad done" if inlist(nosrg1,8,9) & rad1 == 0 & init_tx1 == "n/a"
* assume unknown if unknown rad, and no surg
replace init_tx1 = "unknown if surg or rad done" if inlist(rad1,8,9) & inlist(nosrg1,1,2,5,6) & init_tx1 == "n/a"
* assume rad only, if known rad, but unknown surg
replace init_tx1 = "rad only"  if inlist(rad1,1,2,3,4,5,6) & inlist(nosrg1, 8,9) & init_tx1 == "n/a"
* assume surg only, if known surg, but unknown rad
replace init_tx1 = "surg only" if inlist(nosrg1, 0) & inlist(rad1, 8,9) & init_tx1 == "n/a"
* assume refusal if surg or rad refused, and rad or surg unknown
replace init_tx1 = "pt refused rad or surg" if inlist(nosrg1, 7) & inlist(rad1, 8,9)  & init_tx1 == "n/a"
replace init_tx1 = "pt refused rad or surg" if inlist(nosrg1, 8,9) & inlist(rad1, 7)  & init_tx1 == "n/a"

* look at crosstab
tab init_tx1
encode init_tx1, gen(init_tx1_)
drop init_tx1
rename init_tx1_ init_tx1

* age categories for table 1
hist agedx1, bin(21)  // this is the most normal data I have ever seen.
egen agedx1_cat = cut(agedx1), at(65,70,75,80,85,90,95)

* fix weird tumor sizes
replace e10sz1 = . if e10sz1 == 999

* if cov = C34, malignant neoplasm of bronchus and lung
gen death_lc = 1 if substr(cod10v,1,3) == "C34" & !missing(med_death_dt)
replace death_lc = 0 if substr(cod10v,1,3) != "C34" & !missing(med_death_dt)




* ----------------------------------------------
* ascertain outcome: 
* 0 censorship at end of study td(31Dec2013)
* 1 second primary lung cancer
* 2 death due to malignant neoplasm of bronchus/lung
* 3 death due to other causes
codebook diag_dt1
capture drop outcome
gen outcome = 1 if !missing(splc_dt)  // 2PLC - BUT problematic if they were diagnosed when the died
									  // ie: it was only found out that they had 2PLC after death,
									  // so the actual diagnosis or start of 2PLC is unknown
replace outcome = 2 if !missing(med_death_dt) & death_lc == 1 & outcome != 1
replace outcome = 3 if !missing(med_death_dt) & death_lc == 0 & outcome != 1
replace outcome = . if !missing(med_death_dt) & (med_death_dt <= diag_dt1)
replace outcome = . if !missing(splc_dt) & !missing(med_death_dt) & (med_death_dt <= splc_dt) & outcome != 1
replace outcome = 0 if missing(splc_dt) & missing(med_death_dt)

label define outcome 0 "censored at EOS" 1 "SPLC" 2 "Death due to malig of bronchus/lung" 3 "Death due to other cause"
label values outcome outcome

* look at outcome
tab outcome
tab outcome if rad1 != 0 // exclude None; diagnosed at autopsy
tab splc_flg if rad1 != 0 // exclude None; diagnosed at autopsy

* look at stages for rad1 == 0, and rad1 != 0

gen rad1_ = rad1 != 0
tab aj3sr1 rad1_, col chi

order patient_id outcome diag_dt1 splc_dt med_death_dt death_lc

* create a flag if there is a 2nd primary lung cancer
capture drop splc_flg
gen splc_flg = 0
replace splc_flg = 1 if !missing(splc_dt)
tab splc_flg


* ------------------------------------------------------------------------------
* save an analytical cohort
saveold "/Volumes/QSU/Datasets/SEER_medicare/data/splc", v(12) replace




* HERE* 

use "/Volumes/QSU/Datasets/SEER_medicare/data/splc", clear

* ------------------------------------------------------
* Drop if first diagnosis was done at autopsy
drop if rad1 == 0 // None; diagnosed at autopsy

* table 1
table1, vars(agedx1_cat	cat \     ///
			 init_tx1   cat \       ///
			 race		cat \ 		///
			 s_sex 		cat	\		///
			 frstprm1   cat \       ///
			 hist_cat   cat \       ///
			 aj3sr1     cat \       ///
			 grade1		cat \       ///
			 site1      cat \       ///
			 lat1       cat \       ///
			 yrdx_1     conts \       ///
			 e10ex1     conts \     ///
			 e10nd1     conts \     ///
			 e10sz1     conts \     ///
			 e10pn1     conts \     ///
			 e10ne1     conts \     ///
			 urban      cat \       ///
			 state      cat \       ///
			 ami        cat \       ///
			 asthma     cat \       ///
			 atrial_fib cat \       ///
			 chf        cat \       ///
			 copd       cat \       ///
			 diabetes   cat \       ///
			 hypert     cat \       ///
			 ischemicheart cat \       ///
			 stroke_tia   cat \       ///
			 ) by(splc_flg) format(%2.1f)

			 
			 [ ] stage distribution of "None; diagnosed at autopsy"
			 [ ] show 10 example cases of None; diagnosed (who were excluded)
			 
			 who were included in the actual data
			 
			 cohort of people with followup time - exclude index diagnosed at death
			 2PLC - table of 2PLC stages 1,2,3, death. 
			 send Summer data.
			 
* 2018-06-26 TODO **********************
****************************************

* [ ] go from long on lung cancer sequence to wide, so that each of LC 1...4 has it's own set of cols
* [ ] ascertain outcome (2PLC - if subsequent LC is different histology or, if same histology, is atleast 2years after 1PLC
* [ ] 
