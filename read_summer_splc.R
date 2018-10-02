# reads the patient_ids in and creates a csv of them alone
rm(list=ls())
gc()

splc <- read.delim("/Volumes/QSU/Datasets/SEER_medicare/data/SEER.medicare_271892.csv", sep=",", colClasses = "character")
str(splc)
patid <- splc$patient_id


head(patid)
isid(patid)
pat_id <- data.frame(patient_id = patid)
names(pat_id) <- "PATIENT_ID"
head(pat_id)
pat_id$PATIENT_ID <- as.character(pat_id$PATIENT_ID)
str(pat_id)

pat_id$indic <- 1

# pat_id_ <- pat_id[order(pat_id$PATIENT_ID),]
tail(pat_id)
head(pat_id)
# create list of patient IDs
write.csv(pat_id, "/Volumes/QSU/Datasets/SEER_medicare/data/patient_ids.csv", row.names=FALSE, quote=FALSE)
