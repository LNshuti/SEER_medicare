* opens ICD-O-3 histology file from WHO and saves to dta
* July 3, 2018

cd "~/QSU/SEER-medicare"

insheet using "/Users/echow/QSU/SEER-medicare/data/ICD_O_3/ICD-O-3_CSV-metadata/Morphenglish.txt", clear names

label data "ICD-O-3 metadata morphology (English)"

* get histology from code
gen histology = substr(code, 1, 4)
destring histology, replace

* get behavior from code
gen behavior = substr(code,6,1)
destring behavior, replace

drop code
order histology behavior struct label

* keep only title 
keep if struct == "title"
isid histology behavior

* save out file
saveold "data/ICD_O_3_histbeh", replace
