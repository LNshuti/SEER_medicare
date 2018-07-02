capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "01_clean_pedsf", t replace
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

* open up small version of pedsf
use "/Volumes/QSU/Datasets/SEER_medicare/pedsf/pedsf_small", clear

* go from wide to long
reshape long seq agedx modx yrdx site siterwho hist hist2_ histrec hstst ajccstg aj3sr frstprm intprim beh beh2_ behtrend summ2k grade dxconf lat src e10sz e10ex e10pe e10nd e10pn e10ne cstum nosrg rad radbrn radsurg sssurg sxscop sxsite typefu monrx yearrx vsrtdx srvm srvmflag marst reg, i(patient_id) j(dx_i)

* drop if no cancer... (some of 1...10 were empty)
drop if missing(seq)

label var seq "sequence at diagnosis"
label var agedx "age at diagnosis"
label var modx "month of diagnosis"
label var yrdx "year of diagnosis"
label var site "primary site"
label var siterwho "site recode ICD-O-3/WHO 2008"
label var hist "histologic type ICD-O-3"
label var hist2_ "histology (92-00) ICD-O-2"
label var histrec "histoly recode--broad groupings"
label var hstst "SEER historic stage A"
label var ajccstg "AJCC stage 3rd edition (1988-2003)"
label var aj3sr "SEER modified AJCC stage 3rd ed"
label var frstprm "first malignant primary indicator"
label var intprim "primary by international rules"
label var beh "behavior code ICD-O-3"
label var beh2_ "behavior (92-00) ICD-O-3"
label var behtrend "behavior recode for analysis"
label var summ2k "summary stage 2000 (1998+)"
label var grade "grade"
label var dxconf "diagnostic confirmation"
label var lat "laterality"
label var src "type of reporting source"
label var e10sz "EOD 10 - tumor size"
label var e10ex "EOD 10 - extension"
label var e10pe "EOD 10 - extension prostate path"
label var e10nd "EOD 10 - lymph node involvement"
label var e10pn "EOD 10 - regional node positive"
label var e10ne "EOD 10 - regional nodes examined"
label var cstum "CS tumor size"
label var nosrg "reason for no surgery"
label var rad "RX summ--radiation"
label var radbrn "RX summ--rad to CNS"
label var radsurg "RX summ--surg/rad seq"
label var typefu "SEER typeof followup"
label var monrx "month therapy started"
label var yearrx "year therapy started"
label var vsrtdx "SEER cause-specific death classification"
label var srvm "survival months"
label var srvmflag "survival months flag"
label var marst "marital status at dx"


* ------------------------
* keep cancers in 2000-2013
destring yrdx, gen(yrdx_)
keep if inrange(yrdx_, 2000, 2013)
tab yrdx_

* ----------------------------------
* for each patient sort the sequence
sort patient_id seq
count

* including other cancers, if the first cancer to show up in 2000-2013
* has a sequence >= 2, then a previous unknown cancer occurred prior
* to the study period - we should drop these ppl b/c we don't know if
* that previous unknown cancer is lung cancer.

egen min_seq = min(seq), by(patient_id)
drop if min_seq >= 2  // drop if they had a cancer prior to 2000
count // nearly 14.6% dropped

* ------------------------
* keep only the lung cancers now, the first cancer is now the 1st PLC in 2000-2013
* https://seer.cancer.gov/siterecode/icdo3_dwhoheme/
keep if siterwho == 22030 // keep only lung cancers
keep if agedx >= 65

* If a patient has only one primary malignant or in situ neoplasm, the sequence 
* number assigned is 00. If a patient has multiple primary neoplasms during a 
* lifetime, the sequence number for the first tumor is 01, the sequence number 
* for the second primary tumor is 02, and so forth
*                    1st      2nd
// keep if inlist(seq1, 0,1,     2         ,3,4,5,6,7,8) // keep unbounded




* ------------------------
* must be enrolled in medicare A and B, but not HMO in month of diagnosis
* One indicator for each month in the year.
* 0 = Not entitled, 1 = Part A only, 2 = Part B only, 3 = Part A and B
* Note: mon1 = 1/1991, mon2 = 2/1991, mon3 = 3/1991 ….mon300 = 12/2015

codebook yrdx_
destring modx, gen(modx_)
* make a month index for coverage: gho/mon
gen mo_i = 12*(yrdx_ - 1991)  + modx_
codebook mo_i
* drop if the diagnosis month is unknown
drop if missing(mo_i)

* get lowest mo_i and cycle through
summarize(mo_i)
local min_mo_i = r(min)
forvalues i=`min_mo_i'/300 {
	di "`i'"
  drop if mo_i == `i' & (mon`i' != "3" | gho`i' != "0")
}

* don't need mon or gho anymore
drop mon* gho* mo_i




* clean up the death date 
gen death_dt_ = med_dody + "-" + med_dodm + "-" + med_dodd
gen med_death_dt  = date(death_dt_, "YMD")
format med_death_dt %td
drop death_dt_ med_dody med_dodm med_dodd
label var med_death_dt "medicare date of death"
order med_death_dt

* clean up birth year (assume 15th for middle of month)
gen birth_dt_ = birthyr + "-" + birthm + "-15"  // ASSUME 15th day of month
gen birth_dt  = date(birth_dt_, "YMD")
format birth_dt %td
drop birth_dt_ birthyr birthm yr_brth
label var birth_dt "birth date - accurate to month, assumed 15th"
order patient_id birth_dt med_death_dt

* clean up diagnosis dates

gen diag_dt_ = yrdx + "-" + modx + "-15"  // ASSUME 15th day of month
gen diag_dt  = date(diag_dt_, "YMD")
format diag_dt %td
drop diag_dt_ yrdx modx
label var diag_dt "diagnosis date - accurate to month, assumed 15th"

* encode sex
label define sex 1 "M" 2 "F"
label values s_sex sex

* encode race
label define race 0 "unknown" 1 "white" 2 "black" 3 "other" 4 "asian" 5 "hispanic" 6 "native american"
label values race race

* histrec1 .. 10
label define histology 0 "unspecified neoplasms" 1 "epithelial neoplasms, NOS" 2 "squamous cell neoplams" 3 "basal cell neoplams" 4 "transitional cell papillomas and carcinomas" 5 "adenomas and adenocarcinomas" 6 "adnexal and skin appendage neoplams" 7 "mucoepidermoid neoplasms" 8 "cystic, mucinous and serous neoplams" 9 "ductal and lobular neoplams" 10 "acinar cell neoplasms" 11 "complex epithelial neoplams" 12 "thymic epithelial neoplams" 13 "specialized gonadal neoplams" 14 "paragangliomas and glumus tumors" 15 "nevi and melanomas" 16 "soft tissue tumors and sarcomas, NOS" 17 "fibromatous neoplasms" 18 "myxomatous neoplasms" 19 "lipomatous neoplasms" 20 "myomatous neoplasms" 21 "complex mixed and stromal neoplasms" 22 "fibroepithelial neoplasms" 23 "synovial-like neoplasms" 24 "mesothelial neoplasms" 25 "germ cell neoplasms" 26 "trophoblastic neoplasms" 27 "mesonephromas" 28 "blood vessel tumors" 29 "lymphatic vessel tumors" 30 "osseous and chondromatous neoplasms" 31 "giant cell tumors" 32 "miscellaneous bone tumors (C40._,C41._)" 33 "odontogenic tumors ( C41._)" 34 "miscellaneous tumors" 35 "gliomas" 36 "neuroepitheliomatous neoplasms" 37 "meningiomas" 38 "nerve sheath tumors" 39 "granular cell tumors & alveolar soft part sarcomas" 40 "malignant lymphomas, NOS or diffuse" 41 "hodgkin lymphomas" 42 "nhl - mature b-cell lymphomas" 43 "nhl - mature t and nk-cell lymphomas" 44 "nhl - precursor cell lymphoblastic lymphoma" 45 "plasma cell tumors" 46 "mast cell tumors" 47 "neoplasms of histiocytes and accessory lymphoid cells" 48 "immunoproliferative diseases" 49 "leukemias, nos" 50 "lymphoid leukemias (C42.1)" 51 "myeloid leukemias (C42.1)" 52 "other leukemias (C42.1)" 53 "chronic myeloproliferative disorders (C42.1)" 54 "other hematologic disorders" 55 "myelodysplastic syndrome" 98 "other 
label values histrec histology

* define site
label define site_icd_o_3 0  "External upper lip" 1  "External lower lip" 2  "External lip, NOS" 3  "Mucosa of upper lip" 4  "Mucosa of lower lip" 5  "Mucosa of lip, NOS" 6  "Commissure of lip" 8  "Overlapping lesion of lip" 9  "Lip, NOS" 19  "Base of tongue, NOS" 20  "Dorsal surface of tongue, NOS" 21  "Border of tongue" 22  "Ventral surface of tongue, NOS" 23  "Anterior 2/3 of tongue, NOS" 24  "Lingual tonsil" 28  "Overlapping lesion of tongue" 29  "Tongue, NOS" 30  "Upper Gum" 31  "Lower gum" 39  "Gum, NOS" 40  "Anterior floor of mouth" 41  "Lateral floor of mouth" 48  "Overlapping lesion of floor of mouth" 49  "Floor of mouth, NOS" 50  "Hard palate" 51  "Soft palate, NOS" 52  "Uvula" 58  "Overlapping lesion of palate" 59  "Palate, NOS" 60  "Cheeck mucosa" 61  "Vestibule of mouth" 62  "Retromolar area" 68  "Overlapping lesion of other and unspecified parts of mouth" 69  "Mouth, NOS" 79  "Parotid gland" 80  "Submandibular gland" 81  "Sublingual gland" 88  "Overlapping lesion of major salivary glands" 89  "Major salivary gland, NOS" 90  "Tonsillar fossa" 91  "Tonsillar pillar" 98  "Overlapping lesion of tonsil" 99  "Tonsil, NOS" 100  "Vallecula" 101  "Anterior surface of epiglottis" 102  "Lateral wall of oropharynx" 103  "Posterior wall of oropharynx" 104  "Branchial cleft" 108  "Overlapping lesions of oropharynx" 109  "Oropharynx, NOS" 110  "Superior wall of nasopharynx" 111  "Posterior wall of nasopharynx" 112  "Lateral wall of nasopharynx" 113  "Anterior wall of nasopharynx" 118  "Overlapping lesion of nasopharynx" 119  "Nasopharynx, NOS" 129  "Pyriform sinus" 130  "Postcricoid region" 131  "Hypopharyngeal aspect of aryepiglottic fold" 132  "Posterior wall of hypopharynx" 138  "Overlapping lesion of hypopharynx" 139  "Hypopharynx, NOS" 140  "Pharynx, NOS" 142  "Waldeyer ring" 148  "Overlapping lesion of lip, oral cavity and pharynx" 150  "Cervical esophagus" 151  "Thoracic esophagus" 152  "Abdominal esophagus" 153  "Upper third of esophagus" 154  "Middle third of esophagus" 155  "Lower third of esophagus" 158  "Overlapping lesion of esophagus" 159  "Esophagus, NOS" 160  "Cardia, NOS" 161  "Fundus of stomach" 162  "Body of stomach" 163  "Gastric antrum" 164  "Pylorus" 165  "Lesser curvature of stomach, NOS" 166  "Greater curvature of stomach, NOS" 168  "Overlapping lesion of stomach" 169  "Stomach, NOS" 170  "Duodenum" 171  "Jejunum" 172  "Ileum" 173  "Meckel diverticulum" 178  "Overlapping lesion of small intestine" 179  "Small intestine, NOS" 180  "Cecum" 181  "Appendix" 182  "Ascending colon" 183  "Hepatic flexure of colon" 184  "Transverse colon" 185  "Splenic flexure of colon" 186  "Descending colon" 187  "Sigmoid colon" 188  "Overlapping lesion of colon" 189  "Colon, NOS" 199  "Rectosigmoid junction" 209  "Rectum, NOS" 210  "Anus, NOS" 211  "Anal canal" 212  "Cloacogenic zone" 218  "Overlapping lesion of rectum, anus and anal canal" 220  "Liver" 221  "intrahepatic bile duct" 239  "Gallbladder" 240  "Extrahepatic bile duct" 241  "Ampulla of Vater" 248  "Overlapping lesion of billiary tract" 249  "Billiary tract, NOS" 250  "Head of pancreas" 251  "Body of pancreas" 252  "Tail of pancreas" 253  "Pancreatic duct" 254  "Islets of Langerhans" 257  "Other specified parts of pancreas" 258  "Overlapping lesion of pancreas" 259  "Pancreas, NOS" 260  "Intestinal tract, NOS" 268  "Overlapping lesion of digestive system" 269  "Gastrointestinal tract, NOS" 300  "Nasal cavity" 301  "Middle ear" 310  "Maxillary sinus" 311  "Ethmoid sinus" 312  "Frontal sinus" 313  "Sphenoid sinus" 318  "Overlapping lesion of accessory sinuses" 319  "Accessory sinus, NOS" 320  "Glottis" 321  "Supraglottis" 322  "Subglottis" 323  "Laryngeal cartilage" 328  "Overlapping lesion of larynx" 329  "Larynx, NOS" 339  "Trachea" 340  "Main bronchus" 341  "Upper lobe, lung" 342  "Middle lobe, lung" 343  "Lower lobe, lung" 348  "Overlapping lesion of lung" 349  "Lung, NOS" 379  "Thymus" 380  "Heart" 381  "Anterior mediastinum" 382  "Posterior mediastinum" 383  "Mediastinum, NOS" 384  "Pleura, NOS" 388  "Overlapping lesion of heart, mediastinum and pleura" 390  "Upper respiratory tract, NOS" 398  "Overlapping lesion of respiratory system and intrathoracic organs" 399  "Ill-defined sites within respiratory system" 400  "Long bones of upper limb, scapula and associated joints" 401  "Short bones of upper limb and associated joints" 402  "Long bones of lower limb and associated joints" 403  "Short bones of lower limb and associated joints" 408  "Overlapping lesion of bones, joints and articular cartilage of limbs" 409  "Bone of limb, NOS" 410  "Bones of skull and face and associated joints" 411  "Mandible" 412  "Vertebral column" 413  "Rib, sternum, clavicle and associated joints" 414  "Pelvic bones, sacrum, coccyx and associated joints" 418  "Overlapping lesion of bones, joints and articular cartilage" 419  "Bone, NOS" 420  "Blood" 421  "Bone marrow" 422  "Spleen" 423  "Reticuloendothelial system, NOS" 424  "Hematopoietic system, NOS" 440  "Skin of lip, NOS" 441  "Eyelid" 442  "External ear" 443  "Skin of other and unspecified parts of face" 444  "Skin of scalp and neck" 445  "Skin of trunk" 446  "Skin of upper limb and shoulder" 447  "Skin of lower limb and hip" 448  "Overlapping lesion of skin" 449  "Skin, NOS" 470  "Peripheral nerves and autonomic nervous system of head, face, and neck" 471  "Peripheral nerves and autonomic nervous system of upper limb and shoulder" 472  "Peripheral nerves and autonomic nervous system of lower limb and hip" 473  "Peripheral nerves and autonomic nervous system of thorax" 474  "Peripheral nerves and autonomic nervous system of abdomen" 475  "Peripheral nerves and autonomic nervous system of pelvis" 476  "Peripheral nerves and autonomic nervous system of trunk, NOS" 478  "Overlapping lesion of peripheral nerves and autonomic nervous system" 479  "Autonomic nervous system, NOS" 480  "Retroperitoneum" 481  "Specified parts of peritoneum" 482  "Peritoneum, NOS" 488  "Overlapping lesion of retroperitoneum and peritoneum" 490  "Connective, Subcutaneous and other soft tissues of head, face, and neck" 491  "Connective, Subcutaneous and other soft tissues of upper limb and shoulder" 492  "Connective, Subcutaneous and other soft tissues of lower limb and hip" 493  "Connective, Subcutaneous and other soft tissues of thorax" 494  "Connective, Subcutaneous and other soft tissues of abdomen" 495  "Connective, Subcutaneous and other soft tissues of pelvis" 496  "Connective, Subcutaneous and other soft tissues of trunk, NOS" 498  "Overlapping lesion of connective, subcutaneous and other soft tissues" 499  "Connective, Subcutaneous and other soft tissues, NOS" 500  "Nipple" 501  "Central portion of breast" 502  "Upper-inner quadrant of breast" 503  "Lower-inner quadrant of breast" 504  "Upper-outer quadrant of breast" 505  "Lower-outer quadrant of breast" 506  "Axillary tail of breast" 508  "Overlapping lesion of breast" 509  "Breast, NOS" 510  "Labium majus" 511  "Labium minus" 512  "Clitorus" 518  "Overlapping lesion of vulva" 519  "Vulva, NOS" 529  "Vagina, NOS" 530  "Endocervix" 531  "Exocervix" 538  "Overlapping lesion of cervix uteri" 539  "Cervix uteri" 540  "Isthmus uteri" 541  "Endometrium" 542  "Myometrium" 543  "Fundus uteri" 548  "Overlapping lesion of corpus uteri" 549  "Corpus uteri" 559  "Uterus, NOS" 569  "Ovary" 570  "Fallopian tube" 571  "Broad ligament" 572  "Round ligament" 573  "Parametrium" 574  "Uterine adnexa" 577  "Other specified parts of female genital organs" 578  "Overlapping lesion of female genital organs" 579  "Female genital tract, NOS" 589  "Placenta" 600  "Prepuce" 601  "Glans penis" 602  "Body of penis" 608  "Overlapping lesion of penis" 609  "Penis, NOS" 619  "Prostate gland" 620  "Undescended testis" 621  "Descended testis" 629  "Testis, NOS" 630  "Epididymis" 631  "Spermatic cord" 632  "Scrotum, NOS" 637  "Other specified parts of male genital organs" 638  "Overlapping lesion of male genital organs" 639  "Male genital organs, NOS" 649  "Kidney, NOS" 659  "Renal pelvis" 669  "Ureter" 670  "Trigone of bladder" 671  "Dome of bladder" 672  "Lateral wall of bladder" 673  "Anterior wall of bladder" 674  "Posterior wall of bladder" 675  "Bladder neck" 676  "Ureteric orifice" 677  "Urachus" 678  "Overlapping lesion of bladder" 679  "Bladder, NOS" 680  "Urethra" 681  "Paraurethral gland" 688  "Overlapping lesion of urinary organs" 689  "Urinary system, NOS" 690  "Conjunctiva" 691  "Cornea, NOS" 692  "Retina" 693  "Choroid" 694  "Ciliary body" 695  "Lacrimal gland" 696  "Orbit, NOS" 698  "Overlapping lesion of eye and adnexa" 699  "Eye, NOS" 700  "Cerebral meninges" 701  "Spinal meninges" 709  "Meninges, NOS" 710  "Cerebrum" 711  "Frontal lobe" 712  "Temporal lobe" 713  "Parietal lobe" 714  "Occipital lobe" 715  "Ventricle, NOS" 716  "Cerebellum, NOS" 717  "Brain stem" 718  "Overlapping lesion of brain" 719  "Brain, NOS" 720  "Spinal cord" 721  "Cauda equina" 722  "Olfactory nerve" 723  "Optic nerve" 724  "Acoustic nerve" 725  "Cranial nerve, NOS" 728  "Overlapping lesion of brain and central nervous system" 729  "Nervous system, NOS" 739  "Thyroid gland" 740  "Cortex of adrenal gland" 741  "Medulla of adrenal gland" 749  "Adrenal gland, NOS" 750  "Parathyroid gland" 751  "Pituitary gland" 752  "Craniopharyngeal duct" 753  "Pineal gland" 754  "Carotid body" 755  "Aortic body and other paraganglia" 758  "Overlapping lesion of endocrine glands and related structures" 759  "Endocrine gland, NOS" 760  "Head, face or neck, NOS" 761  "Thorax, NOS" 762  "Abdomen, NOS" 763  "Pelvis, NOS" 764  "Upper limb, NOS" 765  "Lower limb, NOS" 767  "Other ill-defined sites" 768  "Overlapping lesion of ill-defined sites" 770  "Lymph nodes of head, face and neck" 771  "Intrathoracic lymph nodes" 772  "Intra-abdominal lymph nodes" 773  "Lymph nodes of axilla or arm" 774  "Lymph nodes of inguinal region or leg" 775  "Pelvic lymph nodes" 778  "Lymph nodes of multiple regions" 779  "Lymph node, NOS" 809  "Unknown primary site"
label values site site_icd_o_3

* create sequence number of the lung cancer
sort patient_id diag_dt seq
by patient_id: gen seq_lc = _n
label var seq_lc "the sequence of lung cancer in 2000-2013, ie: 1 is the first LC in 2000-2013, etc"
tab seq_lc

order patient_id s_sex race birth_dt med_death_dt seq* diag_dt agedx* histrec*  e10ex* e10nd*
sort patient_id seq

* destring registry
destring registry*, replace force
destring reg2cd*, replace force

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

* compare the yearly number of cases to SEER-Medicare website
* https://healthcaredelivery.cancer.gov/seermedicare/aboutdata/cases.html
tab yrdx if inlist(seq, 0, 1)

* ------------------------------------------------------------------------------
* save an analytical cohort
saveold "/Volumes/QSU/Datasets/SEER_medicare/data/pedsf_analysis_long", v(12) replace








use "/Volumes/QSU/Datasets/SEER_medicare/data/pedsf_analysis_long", clear

* sort by patient id, diag_dt, and histology
sort patient_id diag_dt hist2_

* reshape to wide format
reshape wide  diag_dt hist2_ histrec seq agedx reg  e10* dx_i med_stcd medst_yr marst modx_ yrdx_ site lat  beh2_ hist beh grade dxconf src cstum nosrg rad radbrn radsurg sssurg sxscop sxsite typefu siterwho behtrend hstst ajccstg aj3sr frstprm summ2k vsrtdx intprim srvm srvmflag yearrx, i(patient_id) j(seq_lc)
isid patient_id
order patient_id diag_dt* agedx* hist2_* histrec* hist*

* group histology categories
gen hist_cat = .
replace hist_cat = 0 if histrec1 == 0
replace hist_cat = 1 if histrec1 == 1
replace hist_cat = 2 if histrec1 == 2
replace hist_cat = 3 if histrec1 == 5
replace hist_cat = 99 if inlist(histrec1, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)
replace hist_cat = 99 if inlist(histrec1, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33)
replace hist_cat = 99 if inlist(histrec1, 34, 35, 36, 37, 38, 39, 40)

label define hist_cat 0 "unspecified neoplasms" 1 "epithelial neoplasms, NOS" 2 "squamous cell neoplasms" 3 "adenomoas/adenocarcinomas" 99 "other"
label values hist_cat hist_cat

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
