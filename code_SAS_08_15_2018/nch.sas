/* Published: 12/1/2016 */

/********************** COMMENTS ***************************************/
/* THIS INPUT STATMENT IS FOR THE 2016 SEER-MEDICARE LINKAGE.          */
/* IF YOU RECEIVED NCH FILES BEFORE DECEMBER 2016 THEN YOU WILL        */
/* NEED A DIFFERENT INPUT STATEMENT. PLEASE CONTACT IMS VIA E-MAIL AT  */
/* SEER-MEDICARE@IMSWEB.COM AND AN INPUT STATEMENT WILL BE SENT TO YOU */
/***********************************************************************/
/*                                                                     */
/* For cancer files, Patient Identifier is @01 REGCASE $char10.        */
/* For non-cancer files, Patient Identifier is @01 HICBIC $char11.     */
/*                                                                     */
/***********************************************************************/

/***************   IMPORTANT PROGRAMING NOTES   ************************/
/*               TO IDENTIFY CLAIMS PER PATIENT                        */
/*                                                                     */
/* The Patient ID and Claim ID (column 744) should be used to identify */
/* all the records for each claim per patient.  Both are needed to     */
/* identify a claim.                                                   */

/***********************************************************************/
/* If you are using PC SAS to read in these files you will have to     */
/* un-zip the files first and use the un-zipped filename statement,    */
/* rather than using the zipped files and statement.                   */
/***********************************************************************/

/* read in patient IDs from Summer's file*/ 
data patient_ids;
infile "C:\QSU\SEER\data_in\patient_ids.csv" dlm="," dsd missover firstobs=2;
input patient_id $10.
	  indicator  comma2.;
run;

proc sort data = patient_ids;
by PATIENT_ID;
run;




/* Get a list of the files and keep the NCH ones */
filename indata pipe 'dir "S:\Raw files unzipped" /b';
data file_list;
 length fname $20;
 infile indata truncover; /* infile statement for file names */
 input fname $20.; /* read the file names from the directory */
 call symput ('num_files',_n_); /* store the record number in a macro variable */
run; 

/* keep only files that are outsaf** */
data file_list_nch;
	set file_list(where = (fname contains 'nch'));
run;



/* Runs the SAS code, exporting to a Stata file in the end */
%macro export_to_stata;

%do j = 1 %to &num_files;

/* get the file j of 700 */
data _null_;
	set file_list_nch;
	if _n_=&j;
	call symput ('filein',fname);
run;


filename nchin "S:/Raw files unzipped/&filein";                         /* reading in an un-zipped file */
*filename nchin pipe 'gunzip -c /directory/nch14.txt.gz';      /* reading in a zipped file */
*filename nchin pipe 'gunzip -c /directory/nch*.txt.gz';       /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data nch;
  infile nchin lrecl=757 missover pad;
  INPUT
    @001  PATIENT_ID    $char11. /* Patient ID (for either Cancer or Non-Cancer Patients) */
 /* @001  regcase       $char10. */  /* ID for Cancer Patients */
 /* @001  HICBIC        $char11. */  /* ID for Non Cancer Patients */
    @012  bic           $char2.
    @014  state_cd      $char2.
    @016  cnty_cd       $char3.
    @019  bene_zip      $char9.  /*****Encrypted*****/
    @028  ms_cd         $char2.
    @030  clm_type      $char2.
    @032  from_dtm      $char2.
    @034  from_dtd      $char2.
    @036  from_dty      $char4.
    @040  thru_dtm      $char2.
    @042  thru_dtd      $char2.
    @044  thru_dty      $char4.
    @048  fi_num        $char5.
    @053  entry_cd      $char1.  /* new in 2012 Linkage */
    @055  asgmntcd      $char1.
    @056  rfr_upin      $char6.
    @062  rfr_npi       $char10.
    @072  hcfaspec      $char2.
    @074  prtcptg       $char1.
    @075  proindcd      $char2.  /* formatted $char1. in 2010 Linkage */
    @077  pay80cd       $char1.
    @078  dedind        $char1.
    @079  payindcd      $char1.
    @080  mtuscnt       12.3     /* formatted 8. in 2010 Linkage */
    @092  mtusind       $char1.
    @093  hcpcs         $char5.
    @098  mf1           $char2.  /* named mfrcd1 in 2010 Linkage */
    @100  mf2           $char2.  /* named mfrcd2 in 2010 Linkage */
    @102  mf3           $char2.  /* new in 2012 Linkage */
    @104  mf4           $char2.  /* new in 2012 Linkage */
    @106  lsubmamt      15.2     /* named submamt in 2010 Linkage */
    @121  lalowamt      15.2     /* named alowamt in 2010 Linkage */
    @136  hcfatype      $char1.
    @137  plcsrvc       $char2.
    @139  frexpenm      $char2.
    @141  frexpend      $char2.
    @143  frexpeny      $char4.
    @147  lsexpenm      $char2.
    @149  lsexpend      $char2.
    @151  lsexpeny      $char4.
    @155  srvc_cnt      12.      /* formatted 4. in 2010 Linkage */
    @167  linediag      $char7.  /* formatted $char5. in 2010 Linkage */
    @174  linepmt       15.2
    @189  ldedamt       15.2
    @204  lprpayat      15.2
    @219  lprpaycd      $char1.
    @220  lbenpmt       15.2
    @235  lprvpmt       15.2
    @250  coinamt       15.2
    @265  lintamt       15.2     /* new in 2012 Linkage */
    @280  dedapply      15.2
    @295  prpayamt      15.2
    @310  pmt_amt       15.2
    @325  allowamt      15.2     /* named alowchrg in 2010 Linkage */
    @340  sbmtamt       15.2     /* named sbmtchrg in 2010 Linkage */
    @355  prov_pmt      15.2
    @370  prpyalow      15.2
    @385  prf_prfl      $char10. /* new in 2016 Linkage */
    @399  astnt_cd      $char1.
    @400  hcpcs_yr      $char1.
    @401  rfr_prfl      $char10. /* new in 2016 Linkage */
    @411  perupin       $char6.
    @417  prf_npi       $char10.
    @427  prgrp_npi     $char10.
    @437  prv_type      $char1.
    @438  prvstate      $char2.
    @440  prozip        $char9.
    @449  clinecnt      $char2.
    @478  pdgns_cd      $char7.  /* formatted $char5. in 2010 Linkage */
    @485  cdgncnt       $char2.  /* formatted $char1. in 2010 Linkage */
    @487  (dgn_cd1-dgn_cd12) ($char7.)  /* formatted $char5. in 2010 Linkage */
    @574  benepaid      15.2     /* new in 2012 Linkage */
    @597  nchben_pmt    15.2     /* new in 2012 Linkage */
    @612  cln_tril      $char8.  /* new in 2012 Linkage */
    @620  ansthcnt      12.      /* new in 2012 Linkage */
    @632  llabamt       15.2     /* new in 2012 Linkage */
    @647  llab_num      $char10. /* new in 2012 Linkage */
    @657  price_cd      $char2.  /* new in 2012 Linkage */
    @659  psych_lmt     15.2     /* new in 2012 Linkage */
    @674  ide_num       $char7.  /* new in 2012 Linkage */
    @681  tax_num       $char10. /* new in 2012 Linkage */
    @700  lrx_num       $char30. /* new in 2012 Linkage */
    @730  dup_chk       $char1.  /* new in 2012 Linkage */
    @731  hgb_rslt      $char4.  /* new in 2012 Linkage */
    @735  hgb_type      $char2.  /* new in 2012 Linkage */
    @737  year          $char4.
    @741  rec_count     $char3.
    @744  claim_id      10.      /* new in 2016 Linkage */
    @754  pmtdnlcd      $char2.  /* Moved from column 54 in 2014 Linkage */
    @756  hscrcty       $char1.  /* new in 2016 Linkage */
    ;

  label
    patient_id = 'Patient ID'
 /* regcase    = 'SEER Registry Case Number' */
 /* HICBIC     = 'Non-Cancer Patient ID' */
    bic        = 'Beneficiary Identification Code'
    state_cd   = 'Beneficiary Residence SSA Standard State Code'
    cnty_cd    = 'Beneficiary Residence SSA Standard County Code'
    bene_zip   = 'Beneficiary Mailing Contact ZIP Code'  /*****Encrypted*****/
    ms_cd      = 'CWF Beneficiary Medicare Status Code'
    clm_type   = 'NCH Claim Type Code'
    from_dtm   = 'Claim From Month'
    from_dtd   = 'Claim From Day'
    from_dty   = 'Claim From Year'
    thru_dtm   = 'Claim Through Month'
    thru_dtd   = 'Claim Through Day'
    thru_dty   = 'Claim Through Year'
    fi_num     = 'Carrier Number'
    entry_cd   = 'Carrier Claim Entry Code'
    pmtdnlcd   = 'Carrier Claim Payment Denial Code'
    asgmntcd   = 'Carrier Claim Provider Assignment Indicator Switch'
    rfr_upin   = 'Claim Referring Physician UPIN Number'
    rfr_npi    = 'Claim Referring Physician NPI Number'
    hcfaspec   = 'Line HCFA Provider Specialty Code'
    prtcptg    = 'Line Provider Participating Indicator Code'
    proindcd   = 'Line Processing Indicator Code'
    pay80cd    = 'Line Payment 80%/100% Code'
    dedind     = 'Line Service deductible indicator Switch'
    payindcd   = 'Line Payment Indicator Code'
    mtuscnt    = 'Carrier Line Miles/Time/Units/Services Count'
    mtusind    = 'Carrier Line Miles/Time/Units/Services Indicator Code'
    hcpcs      = 'Line HCPCS Code'
    mf1        = 'Line HCPCS Initial Modifier Code'
    mf2        = 'Line HCPCS Second Modifier Code'
    mf3        = 'Carrier Line HCPCS Third Modifier Code'
    mf4        = 'Carrier Line HCPCS Fourth Modifier Code'
    lsubmamt   = 'Line Submitted Charge Amount'
    lalowamt   = 'Line Allowed Charge Amount'
    hcfatype   = 'Line HCFA Type Service Code'
    plcsrvc    = 'Line Place of Service Code'
    frexpenm   = 'Line First Expense Month'
    frexpend   = 'Line First Expense Day'
    frexpeny   = 'Line First Expense Year'
    lsexpenm   = 'Line Last Expense Month'
    lsexpend   = 'Line Last Expense Day'
    lsexpeny   = 'Line Last Expense Year'
    srvc_cnt   = 'Line Service Count'
    linediag   = 'Line Diagnosis Code'
    linepmt    = 'Line NCH Payment Amount'
    ldedamt    = 'Line Beneficiary Part B Deductible Amount'
    lprpayat   = 'Line Beneficiary Primay Payer Paid Amount'
    lprpaycd   = 'Line Beneficiary Primay Payer Code'
    lbenpmt    = 'Line Beneficiary Payment Amount'
    lprvpmt    = 'Line Provider Payment Amount'
    coinamt    = 'Line Coinsurance Amount'
    lintamt    = 'Line Interest Amount'
    dedapply   = 'Carrier Claim Cash Deductible Applied Amount'
    prpayamt   = 'Carrier Claim Primary Payer Paid Amount'
    pmt_amt    = 'Claim Payment Amount'
    allowamt   = 'NCH Claim Allowed Charge Amount'
    sbmtamt    = 'NCH Carrier Claim Submitted Charge Amount'
    prov_pmt   = 'NCH Claim Provider Payment Amount'
    prpyalow   = 'Line Primary Payer Allowed Charge Amount'
    prf_prfl   = 'Performing Provider PIN Number'
    astnt_cd   = 'Carrier Line Reduced Payment Physician Assistant Code'
    hcpcs_yr   = 'Carrier Claim HCPCS Year Code'
    rfr_prfl   = 'Carrier Referring PIN Physician'
    perupin    = 'Line performing provider UPIN'
    prf_npi    = 'Line performing provider NPI'
    prgrp_npi  = 'Line performing group NPI'
    prv_type   = 'Provider type'
    prvstate   = 'Line NCH Provider State Code'
    prozip     = 'Line performing provider zip'    /*******Encrypted********/
    clinecnt   = 'Claim Total Line Count'
    pdgns_cd   = 'Principal Diagnosis Code'
    cdgncnt    = 'Claim Diagnosis Code Count'
    dgn_cd1    = 'Claim Diagnosis Code #1'
    dgn_cd2    = 'Claim Diagnosis Code #2'
    dgn_cd3    = 'Claim Diagnosis Code #3'
    dgn_cd4    = 'Claim Diagnosis Code #4'
    dgn_cd5    = 'Claim Diagnosis Code #5'
    dgn_cd6    = 'Claim Diagnosis Code #6'
    dgn_cd7    = 'Claim Diagnosis Code #7'
    dgn_cd8    = 'Claim Diagnosis Code #8'
    dgn_cd9    = 'Claim Diagnosis Code #9'
    dgn_cd10   = 'Claim Diagnosis Code #10'
    dgn_cd11   = 'Claim Diagnosis Code #11'
    dgn_cd12   = 'Claim Diagnosis Code #12'
    benepaid   = 'Carrier Claim Beneficiary Paid Amount'
    nchben_pmt = 'NCH Claim Beneficiary Payment Amount'
    cln_tril   = 'Claim Clinical Trial Number'
    ansthcnt   = 'Carrier Line Anesthesia Base Unit Count'
    llabamt    = 'Carrier line clinical lab charge amt.'
    llab_num   = 'Carrier line clinical lab num'
    price_cd   = 'Line Pricing Locality Code'
    psych_lmt  = 'Carrier Line Psychiatric, OT, PT Limit Amount'
    ide_num    = 'Line IDE Number'
    tax_num    = 'Line Provider Tax Number'
    lrx_num    = 'Carrier Line RX Number'
    dup_chk    = 'Line Duplicate Claim Check Indicator Code'
    hgb_rslt   = 'Line Hematocrit/Hemoglobin Result Number'
    hgb_type   = 'Line Hematocrit/Hemoglobin Test Type Code'
    year       = 'Claim Year'
    rec_count  = 'Record Count for Claim'
    claim_id   = 'Claim ID'
    hscrcty    = 'Carrier Line HPSA/Scarcity Indicator Code'
    ;
run;

proc contents data=nch position;
run;





/* Eric added this code                             */ 
/* this is where I subset the variables and the obs */
data nch_small;
	set nch(keep = patient_id claim_id state_cd ms_cd clm_type from_dtm from_dtd from_dty thru_dtm thru_dtd thru_dty rfr_upin rfr_npi hcfaspec hcpcs mf1 mf2 mf3 mf4 lsubmamt lalowamt srvc_cnt linediag linepmt pmt_amt hcpcs_yr prv_type clinecnt pdgns_cd cdgncnt dgn_cd1 dgn_cd2 dgn_cd3 dgn_cd4 dgn_cd5 dgn_cd6 dgn_cd7 dgn_cd8 dgn_cd9 dgn_cd10 dgn_cd11 dgn_cd12 year rec_count);
run;


/* keep only claims that are for certain HCPCS codes */
/* but actually not yet, b/c I don't know which HCPCS I want */ 
data nch_smaller; 
	/*set outpat_small(where = (hcpcs in('G0297','G0298')));*/
	set nch_small(where = (hcpcs not in(''))); /* select all non-empty HCPCS ... omg*/ 
run;

/* merge in the patient IDs and keep only those that merge */ 
/* Vicki showed me this code ... */ 
data nch_smaller_ptid;
	MERGE nch_smaller    patient_ids;            /*merge outpat_smaller to patient_ids */
		  BY Patient_ID;                         /* this is the key, but char/numeric */
run;

/* now keep only if indicator */
data nch_smaller_ptid_ind;
	set nch_smaller_ptid(where = (indicator in (1)));
run;

/* Eric added this code to saveout to Stata file*/ 
LIBNAME SDF "&sasdir";
PROC EXPORT DATA=nch_smaller_ptid_ind
			FILE= "Z:\echow On My Mac\DATA_SEER_medicare\&filein"
			DBMS=STATA REPLACE;
run;


%end; /* close the do loop */
%mend export_to_stata;

/* call macro */
%export_to_stata;

/* now do this many times */
