* make a dta of fips codes for merging
preserve

insheet using "/Users/echow/QSU/SEER-medicare/data/state_fips.csv", clear names

capture destring fips, replace

saveold "~/QSU/SEER-medicare/data/state_fips", replace v(12)


restore
