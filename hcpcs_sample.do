capture log close
clear

cd "~/QSU/SEER-medicare/code"

local start = "$S_TIME"

* ------------------------------------------------------------------------------
* SEER Medicare clean up
* Eric Chow, 04-27-2017
*
* look at sample of HCPCS codes
* ------------------------------------------------------------------------------

set more off

clear 
clear mata
clear matrix
set maxvar 10000 

	use "~/QSU/SEER-medicare/data/DELETE/outsaf00.file001.txt.dta", clear
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file002.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file003.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file004.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file005.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file006.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file007.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file008.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file009.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file010.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file011.txt.dta"
	append using "~/QSU/SEER-medicare/data/DELETE/outsaf00.file012.txt.dta"
    // ... many more
	
	keep  hcpcs
	
	* output a log of some of the HCPCS codes for Summer
	log using "hcpcs", t replace
	tab hcpcs, sort
	capture log close
	

*         ~ fin ~
