# --------------------------------------------------------------
# Create Table 1 for SSc
# copyright Eric Chow, Stanford University, July 2017
#
# --------------------------------------------------------------

rm(list=ls(all=TRUE))
setwd("~/QSU/SEER-medicare")	# set working directory
message(sprintf("------------------------------\n%s \n",date()))

library(tableone)
library(tidyverse)
library(foreign)

splc <- read.dta("/Volumes/QSU/Datasets/SEER_medicare/data/splc.dta")
head(splc)
names(splc)

# variables for table 1
vars <- c("diag_dt1", "agedx1", "histrec1",  "e10ex1", "e10nd1", "yrdx_1", "site1",  "lat1",  "grade1",
"e10sz1",  "e10pe1", "e10pn1" , "e10ne1" , "rad1" , "radbrn1" , "radsurg1", "sssurg1", "aj3sr1",
"frstprm1", "s_sex", "race", "med_death_dt", "urban",  "splc_flg")

splc <- splc[,vars]
# summary(splc)


# ------------------------------------------------------------------------------
# recategorize Variables

splc$died <- !is.na(splc$med_death_dt)

# ------------------------------------------------------------------------------
# Table 1a

# factor variables
fv <- c("s_sex", "race", "died", "frstprm1", "histrec1", "yrdx_1", "site1",  "lat1",  "grade1",
"rad1" , "radbrn1" , "radsurg1", "sssurg1", "siterwho1", "ajccstg1", "aj3sr1", "urban", "splc_flg")
# fisher's exact
xv <- c()
# ranksum vars
sv <- c("agedx1", "e10ex1", "e10nd1", "e10sz1",  "e10pe1", "e10pn1" , "e10ne1" )

tab1 <- NA; tab1 <- CreateTableOne(data = splc, strata="splc_flg", factorVars = fv)
print(tab1, nonnormal = sv, exact = xv)
# ------------------------------------------------------------------------------











# ~ fin ~
