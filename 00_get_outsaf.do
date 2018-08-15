capture log close
clear

cd "~/QSU/SEER-medicare/code"

log using "00_get_outsaf", t replace
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

capture program drop clean_outsaf
program define clean_outsaf
	args file
	
	use "/Users/echow/DATA_SEER_medicare/`file'"

	keep  patient_id claim_id state_cd ms_cd from_dtm from_dtd from_dty ///
	pmt_amt tot_chrg charge tot_line seg_line tot_seg seg_num rec_count year ///
	hcpcs prcdr_cd* prcdrdtm* prcdrdtd* prcdrdty* 
// 	dgn_cd*  
	 	 
	quietly destring  claim_id state_cd ms_cd from_dtm from_dtd from_dty ///
	pmt_amt tot_chrg charge tot_line seg_line tot_seg seg_num rec_count year ///
	prcdr_cd* prcdrdtm* prcdrdtd* prcdrdty*, replace force
	
	drop if missing(charge)
	
	// ALSO: encode the procedure codes?? 	
	label define prcdr 8701	"Pneumoencephalogram"
	label define prcdr 8702	"Other Contrast Radiogram Of Brain And Skull", add
	label define prcdr 8703	"Computerized Axial Tomography Of Bead", add
	label define prcdr 8704	"Other Tomography Of Bead", add
	label define prcdr 8705	"Contrast Dacryocystogram", add
	label define prcdr 8706	"Contrast Radiogram Of Nasopharynx", add
	label define prcdr 8707	"Contrast Laryngogram", add
	label define prcdr 8708	"Cervical Lymphangiogram", add
	label define prcdr 8709	"Other Soft Tissue X-Ray Of Face, Head, And Neck", add
	label define prcdr 8711	"Full-Mouth X-Ray Of Teeth", add
	label define prcdr 8712	"Other Dental X-Ray", add
	label define prcdr 8713	"Temporomandibular Contrast Arthrogram", add
	label define prcdr 8714	"Contrast Radiogram Of Orbit", add
	label define prcdr 8715	"Contrast Radiogram Of Sinus", add
	label define prcdr 8716	"Other X-Ray Of Facial Bones", add
	label define prcdr 8717	"Other X-Ray Of Skull", add
	label define prcdr 8721	"Contrast Myelogram", add
	label define prcdr 8722	"Other X-Ray Of Cervical Spine", add
	label define prcdr 8723	"Other X-Ray Of Thoracic Spine", add
	label define prcdr 8724	"Other X-Ray Of Lumbosacral Spine", add
	label define prcdr 8729	"Other X-Ray Of Spine", add
	label define prcdr 8731	"Endotracheal Bronchogram", add
	label define prcdr 8732	"Other Contrast Bronchogram", add
	label define prcdr 8733	"Mediastinal Pneumogram", add
	label define prcdr 8734	"Intrathoracic Lymphangiogram", add
	label define prcdr 8735	"Contrast Radiogram Of Mammary Ducts", add
	label define prcdr 8736	"Xerography Of Breast", add
	label define prcdr 8737	"Other Mammography", add
	label define prcdr 8738	"Sinogram Of Chest Wall", add
	label define prcdr 8739	"Other Soft Tissue X-Ray Of Chest Wall", add
	label define prcdr 8741	"Computerized Axial Tomography Of Thorax", add
	label define prcdr 8742	"Other Tomography Of Thorax", add
	label define prcdr 8743	"X-Ray Of Ribs, Sternum, And Clavicle", add
	label define prcdr 8744	"Routine Chest X-Ray, So Described", add
	label define prcdr 8749	"Other Chest X-Ray", add
	label define prcdr 8751	"Percutaneous Hepatic Cholangiogram", add
	label define prcdr 8752	"Intravenous Cholangiogram", add
	label define prcdr 8753	"Intraoperative Cholangiogram", add
	label define prcdr 8754	"Other Cholangiogram", add
	label define prcdr 8759	"Other Biliary Tract X-Ray", add
	label define prcdr 8761	"Barium Swallow", add
	label define prcdr 8762	"Upper Gi Series", add
	label define prcdr 8763	"Small Bowel Series", add
	label define prcdr 8764	"Lower Gi Series", add
	label define prcdr 8765	"Other X-Ray Of Intestine", add
	label define prcdr 8766	"Contrast Pancreatogram", add
	label define prcdr 8769	"Other Digestive Tract X-Ray", add
	label define prcdr 8771	"Computerized Axial Tomography Of Kidney", add
	label define prcdr 8772	"Other Nephrotomogram", add
	label define prcdr 8773	"Intravenous Pyelogram", add
	label define prcdr 8774	"Retrograde Pyelogram", add
	label define prcdr 8775	"Percutaneous Pyelogram", add
	label define prcdr 8776	"Retrograde Cystourethrogram", add
	label define prcdr 8777	"Other Cystogram", add
	label define prcdr 8778	"Ileal Conduitogram", add
	label define prcdr 8779	"Other X-Ray Of The Urinary System", add
	label define prcdr 8781	"X-Ray Of Gravid Uterus", add
	label define prcdr 8782	"Gas Contrast Hysterosalpingogram", add
	label define prcdr 8783	"Opaque Dye Contrast Hysterosalpingogram", add
	label define prcdr 8784	"Percutaneous Hysterogram", add
	label define prcdr 8785	"Other X-Ray Of Fallopian Tubes And Uterus", add
	label define prcdr 8789	"Other X-Ray Of Female Genital Organs", add
	label define prcdr 8791	"Contrast Seminal Vesiculogram", add
	label define prcdr 8792	"Other X-Ray Of Prostate And Seminal Vesicles", add
	label define prcdr 8793	"Contrast Epididymogram", add
	label define prcdr 8794	"Contrast Vasogram", add
	label define prcdr 8795	"Other X-Ray Of Epididymis And Vas Deferens", add
	label define prcdr 8799	"Other X-Ray Of Male Genital Organs", add
	label define prcdr 8801	"Computerized Axial Tomography Of Abdomen", add
	label define prcdr 8802	"Other Abdomen Tomography", add
	label define prcdr 8803	"Sinogram Of Abdominal Wall", add
	label define prcdr 8804	"Abdominal Lymphangiogram", add
	label define prcdr 8809	"Other Soft Tissue X-Ray Of Abdominal Wall", add
	label define prcdr 8811	"Pelvic Opaque Dye Contrast Radiography", add
	label define prcdr 8812	"Pelvic Gas Contrast Radiography", add
	label define prcdr 8813	"Other Peritoneal Pneumogram", add
	label define prcdr 8814	"Retroperitoneal Fistulogram", add
	label define prcdr 8815	"Retroperitoneal Pneumogram", add
	label define prcdr 8816	"Other Retroperitoneal X-Ray", add
	label define prcdr 8819	"Other X-Ray Of Abdomen", add
	label define prcdr 8821	"Skeletal X-Ray Of Shoulder And Upper Arm", add
	label define prcdr 8822	"Skeletal X-Ray Of Elbow And Forearm", add
	label define prcdr 8823	"Skeletal X-Ray Of Wrist And Hand", add
	label define prcdr 8824	"Skeletal X-Ray Of Upper Limb, Not Otherwise Specified", add
	label define prcdr 8825	"Pelvimetry", add
	label define prcdr 8826	"Other Skeletal X-Ray Of Pelvis And Hip", add
	label define prcdr 8827	"Skeletal X-Ray Of Thigh, Knee, And Lower Leg", add
	label define prcdr 8828	"Skeletal X-Ray Of Ankle And Foot", add
	label define prcdr 8829	"Skeletal X-Ray Of Lower Limb, Not Otherwise Specified", add
	label define prcdr 8831	"Skeletal Series", add
	label define prcdr 8832	"Contrast Arthrogram", add
	label define prcdr 8833	"Other Skeletal X-Ray", add
	label define prcdr 8834	"Lymphangiogram Of Upper Limb", add
	label define prcdr 8835	"Other Soft Tissue X-Ray Of Upper Limb", add
	label define prcdr 8836	"Lymphangiogram Of Lower Limb", add
	label define prcdr 8837	"Other Soft Tissue X-Ray Of Lower Limb", add
	label define prcdr 8838	"Other Computerized Axial Tomography", add
	label define prcdr 8839	"X-Ray, Other And Unspecified", add
	label define prcdr 8840	"Arteriography Using Contrast Material, Unspecified Site", add
	label define prcdr 8841	"Arteriography Of Cerebral Arteries", add
	label define prcdr 8842	"Aortography", add
	label define prcdr 8843	"Arteriography Of Pulmonary Arteries", add
	label define prcdr 8844	"Arteriography Of Other Intrathoracic Vessels", add
	label define prcdr 8845	"Arteriography Of Renal Arteries", add
	label define prcdr 8846	"Arteriography Of Placenta", add
	label define prcdr 8847	"Arteriography Of Other Intra-Abdominal Arteries", add
	label define prcdr 8848	"Arteriography Of Femoral And Other Lower Extremity Arteries", add
	label define prcdr 8849	"Arteriography Of Other Specified Sites", add
	label define prcdr 8850	"Angiocardiography, Not Otherwise Specified", add
	label define prcdr 8851	"Angiocardiography Of Venae Cavae", add
	label define prcdr 8852	"Angiocardiography Of Right Heart Structures", add
	label define prcdr 8853	"Angiocardiography Of Left Heart Structures", add
	label define prcdr 8854	"Combined Right And Left Heart Angiocardiography", add
	label define prcdr 8855	"Coronary Arteriography Using A Single Catheter", add
	label define prcdr 8856	"Coronary Arteriography Using Two Catheters", add
	label define prcdr 8857	"Other And Unspecified Coronary Arteriography", add
	label define prcdr 8858	"Negative-Contrast Cardiac Roentgenography", add
	label define prcdr 8859	"Intra-Operative Fluorescence Vascular Angiography", add
	label define prcdr 8860	"Phlebography Using Contrast Material, Unspecified Site", add
	label define prcdr 8861	"Phlebography Of Veins Of Head And Neck Using Contrast Material", add
	label define prcdr 8862	"Phlebography Of Pulmonary Veins Using Contrast Material", add
	label define prcdr 8863	"Phlebography Of Other Intrathoracic Veins Using Contrast Material", add
	label define prcdr 8864	"Phlebography Of The Portal Venous System Using Contrast Material", add
	label define prcdr 8865	"Phlebography Of Other Intra-Abdominal Veins Using Contrast Material", add
	label define prcdr 8866	"Phlebography Of Femoral And Other Lower Extremity Veins Using Contrast Material", add
	label define prcdr 8867	"Phlebography Of Other Specified Sites Using Contrast Material", add
	label define prcdr 8868	"Impedance Phlebography", add
	label define prcdr 8871	"Diagnostic Ultrasound Of Head And Neck", add
	label define prcdr 8872	"Diagnostic Ultrasound Of Heart", add
	label define prcdr 8873	"Diagnostic Ultrasound Of Other Sites Of Thorax", add
	label define prcdr 8874	"Diagnostic Ultrasound Of Digestive System", add
	label define prcdr 8875	"Diagnostic Ultrasound Of Urinary System", add
	label define prcdr 8876	"Diagnostic Ultrasound Of Abdomen And Retroperitoneum", add
	label define prcdr 8877	"Diagnostic Ultrasound Of Peripheral Vascular System", add
	label define prcdr 8878	"Diagnostic Ultrasound Of Gravid Uterus", add
	label define prcdr 8879	"Other Diagnostic Ultrasound", add
	label define prcdr 8881	"Cerebral Thermography", add
	label define prcdr 8882	"Ocular Thermography", add
	label define prcdr 8883	"Bone Thermography", add
	label define prcdr 8884	"Muscle Thermography", add
	label define prcdr 8885	"Breast Thermography", add
	label define prcdr 8886	"Blood Vessel Thermography", add
	label define prcdr 8889	"Thermography Of Other Sites", add
	label define prcdr 8890	"Diagnostic Imaging, Not Elsewhere Classified", add
	label define prcdr 8891	"Magnetic Resonance Imaging Of Brain And Brain Stem", add
	label define prcdr 8892	"Magnetic Resonance Imaging Of Chest And Myocardium", add
	label define prcdr 8893	"Magnetic Resonance Imaging Of Spinal Canal", add
	label define prcdr 8894	"Magnetic Resonance Imaging Of Musculoskeletal", add
	label define prcdr 8895	"Magnetic Resonance Imaging Of Pelvis, Prostate, And Bladder", add
	label define prcdr 8896	"Other Intraoperative Magnetic Resonance Imaging", add
	label define prcdr 8897	"Magnetic Resonance Imaging Of Other And Unspecified Sites", add
	label define prcdr 8898	"Bone Mineral Density Studies", add
	label define prcdr 9201	"Thyroid Scan And Radioisotope Function Studies", add
	label define prcdr 9202	"Liver Scan And Radioisotope Function Study", add
	label define prcdr 9203	"Renal Scan And Radioisotope Function Study", add
	label define prcdr 9204	"Gastrointestinal Scan And Radioisotope Function Study", add
	label define prcdr 9205	"Cardiovascular And Hematopoietic Scan And Radioisotope Function Study", add
	label define prcdr 9209	"Other Radioisotope Function Studies", add
	label define prcdr 9211	"Cerebral Scan", add
	label define prcdr 9212	"Scan Of Other Sites Of Head", add
	label define prcdr 9213	"Parathyroid Scan", add
	label define prcdr 9214	"Bone Scan", add
	label define prcdr 9215	"Pulmonary Scan", add
	label define prcdr 9216	"Scan Of Lymphatic System", add
	label define prcdr 9217	"Placental Scan", add
	label define prcdr 9218	"Total Body Scan", add
	label define prcdr 9219	"Scan Of Other Sites", add
	label define prcdr 9220	"Infusion Of Liquid Brachytherapy Radioisotope", add
	label define prcdr 9221	"Superficial Radiation", add
	label define prcdr 9222	"Orthovoltage Radiation", add
	label define prcdr 9223	"Radioisotopic Teleradiotherapy", add
	label define prcdr 9224	"Teleradiotherapy Using Photons", add
	label define prcdr 9225	"Teleradiotherapy Using Electrons", add
	label define prcdr 9226	"Teleradiotherapy Of Other Particulate Radiation", add
	label define prcdr 9227	"Implantation Or Insertion Of Radioactive Elements", add
	label define prcdr 9228	"Injection Or Instillation Of Radioisotopes", add
	label define prcdr 9229	"Other Radiotherapeutic Procedure", add
	label define prcdr 9230	"Stereotactic Radiosurgery, Not Otherwise Specified", add
	label define prcdr 9231	"Single Source Photon Radiosurgery", add
	label define prcdr 9232	"Multi-Source Photon Radiosurgery", add
	label define prcdr 9233	"Particulate Radiosurgery", add
	label define prcdr 9239	"Stereotactic Radiosurgery, Not Elsewhere Classified", add
	label define prcdr 9241	"Intra-Operative Electron Radiation Therapy", add

	* apply labels
	label values prcdr_cd*  prcdr
	 
	* clean up the dates (x13)
	forval i = 1/13 {
		tostring prcdrdty`i', replace
		tostring prcdrdtm`i', replace
		tostring prcdrdtd`i', replace
		gen prcdr_dt`i' = prcdrdty`i' + "-" + prcdrdtm`i' + "-" + prcdrdtd`i'
		gen prcdr_dt`i'_ = date(prcdr_dt`i', "YMD")
		format %td prcdr_dt`i'_
		drop prcdr_dt`i' prcdrdty`i' prcdrdtm`i' prcdrdtd`i'
		rename prcdr_dt`i'_ prcdr_dt`i'
	}
	
	compress 
	saveold "/Users/echow/DATA_SEER_medicare/small_`file'", v(12) replace
end



* -------------------------------------------------------
* clean and compress 700 files

* test one file
if (1==0) {
	clean_outsaf "outsaf00.file001.txt.dta"
}

* look for outpat files
local outpat_files: dir "/Users/echow/DATA_SEER_medicare" files "outsaf*"	 // upper case

* compress and save out 700 dta files
foreach file of local outpat_files {
	clean_outsaf "`file'"
}





* -------------------------------------------------------
* append the 700 files

use "/Users/echow/DATA_SEER_medicare/small_outsaf00.file001.txt.dta", clear
gen file = 1


local i = 1
* look for outpat files (SMALL)
local outpat_sm_files: dir "/Users/echow/DATA_SEER_medicare" files "small_outsaf*"	 // upper case

* compress and save out 700 dta files
foreach file of local outpat_sm_files {
	if (`i' == 1) {
		* do nothing
	}
	if (`i' > 1)  {
// 		di "`file'"
		append using "/Users/echow/DATA_SEER_medicare/`file'"
		replace file = `i' if missing(file)
	}
	local i = `i' + 1  // increment i
}

compress
* save as one file
saveold "/Users/echow/DATA_SEER_medicare/small_outsaf_APPENDED", v(12) replace


log close
*         ~ fin ~
