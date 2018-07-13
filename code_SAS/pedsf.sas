/*Published: 12/01/2016*/
/***********************************************************************/
/* IF YOU RECEIVED THE PEDSF FILE BEFORE DECEMBER 2016 THEN YOU WILL   */
/* NEED A DIFFERENT INPUT STATEMENT. PLEASE CONTACT IMS VIA E-MAIL     */
/* SEER-MEDICARE@IMSWEB.COM AND AN INPUT STATEMENT WILL BE SENT TO     */
/* YOU.                                                                */
/* This input statement is used to read in the pedsf.cancer.txt        */
/* file.                                                               */
/***********************************************************************/

*filename inped '/directory/pedsf.cancer.txt';                             /*reading in an unzipped file*/
filename inped 'S:/Raw files unzipped/pedsf.lung.cancer.file06.txt';       /*reading in a zipped file*/

options nocenter validvarname=upcase;


data pedsf06(drop=i pos begin end inc p inc2);
  infile inped lrecl=5442 missover pad;
  input
      @0001  patient_id $char10.
   /*   @0001  reg        $char2.  */
   /*   @0003  casenum    $char8.  */
      @0011  fivepct   $char1.
      @0012  mat_type  $char1.
      @0013  yobflg1   $char1.
      @0014  dobflg2   $char1.
      @0015  yodflg3   $char1.
      @0016  sexflg4   $char1.
      @0017  lstflg5   $char1.
      @0018  fstflg6   $char1.
      @0019  mobflg7   $char1.
      @0020  midflg8   $char1.
      @0021  numdigit  $char1.
      @0022  dod_flg   $char1.
      @0023  dob_flg   $char1.
      @0024  linkflag  $char1.
      @0025  med_dodm  $char2.
      @0027  med_dodd  $char2.
      @0029  med_dody  $char4.
      @0033  birthm    $char2.
      @0037  birthyr   $char4.
      @0041  m_sex     $char1.
      @0042  race      $char1.
      @0043  rsncd1    $char1.
      @0044  cur_ent   $char1.
      @0045  cur_yr    $char4.
      @0049  chr_esrd  $char1.
      @0050  chr_esrd_yr $char4.
      @0054  first_esrd_yr $char4.   /*added in 2016 linkage*/
      @0058  med_stcd  $char2.
      @0060  medst_yr  $char4.
      @0064  VRFYDTH   $char1.
      @0065  STATE     $char2.
      @0067  COUNTY    $char3.
      @0070  zip5      $char5.     /*First five digits of the zip code are encrypted unless approved to recieve zip code*/
      @0075  zip4      $char4.     /*Last four digits of the zip code are blank if permission to zip code is not approved*/
      @0079  code_sys  $char1.
      @0080  tract1990 $char6.     /*encrypted census tract 1990.  Special permission is needed to get unencrypted census code*/
                                   /* LINK 2016 - CHANGED variable name from tract to tract1990*/
      @0086  tract2000 $char6.     /*encrypted census tract 2000.  Special permission is needed to get unencrypted census code*/
                                   /* LINK 2016 - CHANGED variable name from tract2k to tract2000*/
      @0092  tract2010 $char6.     /*encrypted census tract 2010.  Special permission is needed to get unencrypted census code*/ /*added in 2014 linkage*/
      @0098  HSA       $char3.
      @0101  URBRUR    $char1.
      @0102  URBAN     $char2.
      @0104  S_SEX     $char1.
      @0105  RAC_RECB  $char2.
      @0107  RAC_RECY  $char1.
      @0108  RAC_RECA  $char1.
      @0109  ICD_CODE  $char1.
      @0110  COD89V    $char4.
      @0114  COD10V    $char4.
      @0118  codkm     $char5.
      @0123  codpub    $char5.
      @0128  nhiade    $char1.
      @0129  SER_DODM  $char2.
      @0131  SER_DODY  $char4.
      @0135  deathflag $char2.
      @0137  sRACE     $char2.
      @0139  ORIGIN    $char1.
      @0140  origrecb  $char1.
      /*@0141  filler    $char1.*/
      @0142  STAT_REC  $char1.
      @0143  cen_cert  $char1.
      @0144  ctcer2k   $char1.
      @0145  ctcer2010 $char1.     /*added in 2014 linkage*/
      @0146  census_pov_ind $char1. /*added in 2014 linkage*/
      @0147  yr_brth   $char4.
      @0151  dbrflag   $char2.
      @0153  COUNT     $char2.
      @0157  RESNREC   $char1.
      @0164  oshufcase $char8.
      /*@0172  filler    $char53.*/

      @0225  (plan07_01-plan07_12) ($char1.)
      @0237  (dual07_01-dual07_12) ($char2.)
      @0261  ptd07       $char2.
      @0263  dualcnt07   $char2.

      @0265  (plan08_01-plan08_12) ($char1.)
      @0277  (dual08_01-dual08_12) ($char2.)
      @0301  ptd08       $char2.
      @0303  dualcnt08   $char2.

      @0305  (plan09_01-plan09_12) ($char1.)
      @0317  (dual09_01-dual09_12) ($char2.)
      @0341  ptd09       $char2.
      @0343  dualcnt09   $char2.

      @0345  (plan10_01-plan10_12) ($char1.)
      @0357  (dual10_01-dual10_12) ($char2.)
      @0381  ptd10       $char2.
      @0383  dualcnt10   $char2.

      @0385  (plan11_01-plan11_12) ($char1.)
      @0397  (dual11_01-dual11_12) ($char2.)
      @0421  ptd11       $char2.
      @0423  dualcnt11   $char2.

      @0425  (plan12_01-plan12_12) ($char1.)
      @0437  (dual12_01-dual12_12) ($char2.)
      @0461  ptd12       $char2.
      @0463  dualcnt12   $char2.

      @0465  (plan13_01-plan13_12) ($char1.)
      @0477  (dual13_01-dual13_12) ($char2.)
      @0501  ptd13       $char2.
      @0503  dualcnt13   $char2.

      @0505  (plan14_01-plan14_12) ($char1.)
      @0517  (dual14_01-dual14_12) ($char2.)
      @0541  ptd14       $char2.
      @0543  dualcnt14   $char2.

      @;

      inc=590;
      retain begin end;
      begin=1;
      end=12;

  array enta(25)     $ 2 ptacnt1991-ptacnt2015;
  array entb(25)     $ 2 ptbcnt1991-ptbcnt2015;
  array hmoc(25)     $ 2 hmocnt1991-hmocnt2015;
  array stbuy(25)      $ 2 stbuyin1991-stbuyin2015;
  array enmon(300)     $ 1 mon1-mon300;
  array ghon(300)      $ 1 gho1-gho300;
  array allflag(300)   $ 1 allflag1-allflag300;
  array zips5(25)      $ 5 zip5_1991-zip5_2015;
  array zips4(25)      $ 4 zip4_1991-zip4_2015;
  array registry(25)   $ 2 registry1991-registry2015;
  array regcd2(25)     $ 2 reg2cd1991-reg2cd2015;
  array st_edb(25)     $ 2 state1991-state2015;
  array cnty_edb(25)   $ 3 cnty1991-cnty2015;

      do i = 1 to 25;
        do p = begin to end;
        input
            @inc      enmon(p)   $char1.
            @inc + 12 ghon(p)    $char1.
            @inc + 24 allflag(p) $char1.
            @;
            inc=inc + 1;
            end;
        begin = begin + 12;
        end = end + 12;
      input
          @inc + 24  enta(i) $char2.
          @inc + 26  entb(i) $char2.
          @inc + 28  hmoc(i) $char2.
          @inc + 30  stbuy(i)  $char2.
          @;
          inc=inc + 32;
     end;

     inc2= 1734;
       do i = 1 to 25;
       input
           @inc2      zips5(i)    $char5.
           @inc2 + 5  zips4(i)    $char4.
           @inc2 + 9  registry(i) $char2.
           @inc2 +11  regcd2(i)   $char2.
           @inc2 +13  st_edb(i)   $char2.                            /*added in 2016 Linkage*/
           @inc2 +15  cnty_edb(i) $char3.                            /*added in 2016 Linkage*/
           @;
           inc2=inc2+18;
       end;

  array registry4(10)  $  reg1-reg10;
  array marst(10)      $  marst1-marst10;
  array agedx(10)      $  agedx1-agedx10;
  array seq(10)        $  seq1-seq10;
  array modx(10)       $  modx1-modx10;
  array yrdx(10)       $  yrdx1-yrdx10;
  array site(10)       $  site1-site10;
  array lat(10)        $  lat1-lat10;
  array hist_2(10)     $  hist2_1-hist2_10;
  array beh_2(10)      $  beh2_1-beh2_10;
  array hist(10)       $  hist1-hist10;
  array beh(10)        $  beh1-beh10;
  array grade(10)      $  grade1-grade10;
  array dxconf(10)     $  dxconf1-dxconf10;
  array src(10)        $  src1-src10;
  array e10sz(10)      $  e10sz1-e10sz10;
  array e10ex(10)      $  e10ex1-e10ex10;
  array e10pe(10)      $  e10pe1-e10pe10;
  array e10nd(10)      $  e10nd1-e10nd10;
  array e10pn(10)      $  e10pn1-e10pn10;
  array e10ne(10)      $  e10ne1-e10ne10;
  array e13_1(10)      $  e13_1_1-e13_1_10;
  array e13_2(10)      $  e13_2_1-e13_2_10;
  array e13_3(10)      $  e13_3_1-e13_3_10;
  array e13_4(10)      $  e13_4_1-e13_4_10;
  array e13_5(10)      $  e13_5_1-e13_5_10;
  array e13_6(10)      $  e13_6_1-e13_6_10;
  array e13_7(10)      $  e13_7_1-e13_7_10;
  array e13_8(10)      $  e13_8_1-e13_8_10;
  array e13_9(10)      $  e13_9_1-e13_9_10;
  array e13_10(10)     $  e13_10_1-e13_10_10;
  array e13_11(10)     $  e13_11_1-e13_11_10;
  array e13_12(10)     $  e13_12_1-e13_12_10;
  array e13_13(10)     $  e13_13_1-e13_13_10;
  array e2_1(10)       $  e2_1_1-e2_1_10;
  array e2_2(10)       $  e2_2_1-e2_2_10;
  array e4siz(10)      $  e4siz1-e4siz10;
  array e4ext(10)      $  e4ext1-e4ext10;
  array e4nod(10)      $  e4nod1-e4nod10;
  array eodcde(10)     $  eod_cd1-eod_cd10;
  array tumor1(10)     $  tumor1_1-tumor1_10;
  array tumor2(10)     $  tumor2_1-tumor2_10;
  array tumor3(10)     $  tumor3_1-tumor3_10;
  array cstum(10)      $  cstum1-cstum10;
  array csex(10)       $  csex1-csex10;
  array cslym(10)      $  cslym1-cslym10;
  array csmet(10)      $  csmet1-csmet10;
  array cssite1(10)    $  cs1st1-cs1st10;
  array cssite2(10)    $  cs2st1-cs2st10;
  array cssite3(10)    $  cs3st1-cs3st10;
  array cssite4(10)    $  cs4st1-cs4st10;
  array cssite5(10)    $  cs5st1-cs5st10;
  array cssite6(10)    $  cs6st1-cs6st10;
  array cssite25(10)   $  cs25st1-cs25st10;
  array dajccts(10)    $  dajcct1-dajcct10;
  array dajccns(10)    $  dajccn1-dajccn10;
  array dajccms(10)    $  dajccm1-dajccm10;
  array dajcstg(10)    $  dajccstg1-dajccstg10;
  array dss77s(10)     $  dss77s1-dss77s10;
  array dss00s(10)     $  dss00s1-dss00s10;
  array dajcflg(10)    $  dajcflg1-dajcflg10;
  array dss77f(10)     $  dss77f1-dss77f10;
  array dss00f(10)     $  dss00f1-dss00f10;
  array csvf(10)       $  csvf1-csvf10;
  array csvl(10)       $  csvl1-csvl10;
  array cscur(10)      $  cscurrent1-cscurrent10;
  array sxprif(10)     $  sxprif1-sxprif10;
  array sxscof(10)     $  sxscof1-sxscof10;
  array sxsitf(10)     $  sxsitf1-sxsitf10;
  array numnd(10)      $  numnd1-numnd10;
  array recstr(10)     $  recstr1-recstr10;
  array nosrg(10)      $  nosrg1-nosrg10;
  array rad(10)        $  rad1-rad10;
  array radbrn(10)     $  radbrn1-radbrn10;
  array radsurg(10)    $  radsurg1-radsurg10;
  array sssurg(10)     $  sssurg1-sssurg10;
  array sxscop(10)     $  sxscop1-sxscop10;
  array sxsite(10)     $  sxsite1-sxsite10;
  array ositage(10)    $  ositage1-ositage10;
  array oseqcon(10)    $  oseqcon1-oseqcon10;
  array oseqlat(10)    $  oseqlat1-oseqlat10;
  array osurcon(10)    $  osurcon1-osurcon10;
  array osittyp(10)    $  osittyp1-osittyp10;
  array hbenign(10)    $  hbenign1-hbenign10;
  array orptsrc(10)    $  orptsrc1-orptsrc10;
  array odfsite(10)    $  odfsite1-odfsite10;
  array oleukdx(10)    $  oleukdx1-oleukdx10;
  array ositbeh(10)    $  ositbeh1-ositbeh10;
  array oeoddt(10)     $  oeoddt1-oeoddt10;
  array ositeod(10)    $  ositeod1-ositeod10;
  array ositmor(10)    $  ositmor1-ositmor10;
  array typefu(10)     $  typefu1-typefu10;
  array ager(10)       $  ager1-ager10;
  array sterwho(10)    $  siterwho1-siterwho10;
  array icd09(10)      $  icdot09_1-icdot09_10;
  array icd10(10)      $  icdot10_1-icdot10_10;
  array ICCC3_WH(10)   $  ICCC3WHO1-ICCC3WHO10;
  array ICC3X_WH(10)   $  ICC3XWHO1-ICC3XWHO10;
  array behtrnd(10)    $  behtrend1-behtrend10;
  array histrecs(10)   $  histrec1-histrec10;
  array hisrcb(10)     $  hisrcb1-hisrcb10;
  array cs04sch(10)    $  cs04sch1-cs04sch10;
  array hstst(10)      $  hstst1-hstst10;
  array ajccstg(10)    $  ajccstg1-ajccstg10;
  array aj3sr(10)      $  aj3sr1-aj3sr10;
  array sss77(10)      $  sss77v1-sss77v10;
  array sssm2z(10)     $  sssm2Z1-sssm2Z10;
  array frstprm(10)    $  frstprm1-frstprm10;
  array statecd(10)    $  statecd1-statecd10;
  array cnty(10)       $  cnty1-cnty10;
  array ihscd(10)      $  ihscd1-ihscd10;
  array sum2k(10)      $  summ2k1-summ2k10;
  array aya_who(10)    $  ayawho1-ayawho10;
  array lym_who(10)    $  lymwho1-lymwho10;
  array vsrtdx(10)     $  vsrtdx1-vsrtdx10;
  array odthcls(10)    $  odthclass1-odthclass10;
  array csts(10)       $  csts1-csts10;
  array csrg(10)       $  csrg1-csrg10;
  array csmt(10)       $  csmt1-csmt10;
  array intprims(10)   $  intprim1-intprim10;
  array erstat(10)     $  erstat1-erstat10;
  array prstat(10)     $  prstat1-prstat10;
  array cssch(10)      $  cssch1-cssch10;
  array cssite8(10)    $  cs8st1-cs8st10;
  array cssite10(10)   $  cs10st1-cs10st10;
  array cssite11(10)   $  cs11st1-cs11st10;
  array cssite13(10)   $  cs13st1-cs13st10;
  array cssite15(10)   $  cs15st1-cs15st10;
  array cssite16(10)   $  cs16st1-cs16st10;
  array vasinvv(10)    $  vasinv1-vasinv10;
  /*  Public variables added in 2014 linkage  */
  array srvm(10)       $  srvm1-srvm10;
  array srvmflag(10)   $  srvmflag1-srvmflag10;
  array insrecpb(10)   $  insrecpb1-insrecpb10;
  array dajcc7ts(10)   $  dajcc7t1-dajcc7t10;
  array dajcc7ns(10)   $  dajcc7n1-dajcc7n10;
  array dajcc7ms(10)   $  dajcc7m1-dajcc7m10;
  array dajcc7(10)     $  dajcc7_01-dajcc7_10;
  array adjajc6t(10)   $  adjajc6t1-adjajc6t10;
  array adjajc6n(10)   $  adjajc6n1-adjajc6n10;
  array adjajc6m(10)   $  adjajc6m1-adjajc6m10;
  array adjajc6(10)    $  adjajc6_01-adjajc6_10;
  array cssite7(10)    $  cs7st1-cs7st10;
  array cssite9(10)    $  cs9st1-cs9st10;
  array cssite12(10)   $  cs12st1-cs12st10;
  array her2rec(10)    $  her2rec1-her2rec10;
  array brstsub(10)    $  brstsub1-brstsub10;
  array anarbor(10)    $  annarbor1-annarbor10;

  /*  Public variables added in 2016 linkage  */
  array csmetb(10)     $  csmetsdxb_pub1-csmetsdxb_pub10;
  array csmetbr(10)    $  csmetsdxbr_pub1-csmetsdxbr_pub10;
  array csmetliv(10)   $  csmetsdxliv_pub1-csmetsdxliv_pub10;
  array csmetlun(10)   $  csmetsdxlung_pub1-csmetsdxlung_pub10;
  array tvalue(10)     $  t_value1-t_value10;
  array nvalue(10)     $  n_value1-n_value10;
  array mvalue(10)     $  m_value1-m_value10;

/*not public but on PEDSF and released*/
  array ddxflg(10)     $  ddxflag1-ddxflag10;
  array dthflg(10)     $  dthflag1-dthflag10;
  array monrx(10)      $  monrx1-monrx10;
  array yr_rx(10)      $  yearrx1-yearrx10;
  array other_tx(10)   $  other_tx1-other_tx10;
  array icdo(10)       $  icdo1-icdo10;
  array napia_cd(10)   $  napiia1-napiia10;
  array payer_dx(10)   $  payer_dx1-payer_dx10;

/*Not public but on PEDSF.  Need Special Permission*/
  array onco_sc(10)    $ onco_score1-onco_score10;
  array onco_rg(10)    $ onco_rg1-onco_rg10;
  array onco_rns(10)   $ onco_rns1-onco_rns10;
  array onco_yr(10)    $ onco_year1-onco_year10;
  array onco_mon(10)   $ onco_month1-onco_month10;
  array onco_tm(10)    $ onco_time1-onco_time10;

  pos = 2202;
  do i = 1 to 10;
     input
         @(pos +000) registry4(i) $char2.
         @(pos +002) marst(i)    $char1.
         @(pos +003) agedx(i)    $char3.
         @(pos +006) seq(i)      $char2.
         @(pos +008) modx(i)     $char2.
         @(pos +010) yrdx(i)     $char4.
         @(pos +014) site(i)     $char3.
         @(pos +017) lat(i)      $char1.
         @(pos +018) hist_2(i)   $char4.
         @(pos +022) beh_2(i)    $char1.
         @(pos +023) hist(i)     $char4.
         @(pos +027) beh(i)      $char1.
         @(pos +028) grade(i)    $char1.
         @(pos +029) dxconf(i)   $char1.
         @(pos +030) src(i)      $char1.
         @(pos +031) e10sz(i)    $char3.
         @(pos +034) e10ex(i)    $char2.
         @(pos +036) e10pe(i)    $char2.
         @(pos +038) e10nd(i)    $char1.
         @(pos +039) e10pn(i)    $char2.
         @(pos +041) e10ne(i)    $char2.
         @(pos +043) e13_1(i)    $char1.
         @(pos +044) e13_2(i)    $char1.
         @(pos +045) e13_3(i)    $char1.
         @(pos +046) e13_4(i)    $char1.
         @(pos +047) e13_5(i)    $char1.
         @(pos +048) e13_6(i)    $char1.
         @(pos +049) e13_7(i)    $char1.
         @(pos +050) e13_8(i)    $char1.
         @(pos +051) e13_9(i)    $char1.
         @(pos +052) e13_10(i)   $char1.
         @(pos +053) e13_11(i)   $char1.
         @(pos +054) e13_12(i)   $char1.
         @(pos +055) e13_13(i)   $char1.
         @(pos +056) e2_1(i)     $char1.
         @(pos +057) e2_2(i)     $char1.
         @(pos +058) e4siz(i)    $char2.
         @(pos +060) e4ext(i)    $char1.
         @(pos +061) e4nod(i)    $char1.
         @(pos +062) eodcde(i)   $char1.
         @(pos +063) tumor1(i)   $char1.
         @(pos +064) tumor2(i)   $char1.
         @(pos +065) tumor3(i)   $char1.
         @(pos +066) cstum(i)    $char3.
         @(pos +069) csex(i)     $char3.
         @(pos +072) cslym(i)    $char3.
         @(pos +075) csmet(i)    $char2.
         @(pos +077) cssite1(i)  $char3.
         @(pos +080) cssite2(i)  $char3.
         @(pos +083) cssite3(i)  $char3.
         @(pos +086) cssite4(i)  $char3.
         @(pos +089) cssite5(i)  $char3.
         @(pos +092) cssite6(i)  $char3.
         @(pos +095) cssite25(i) $char3.
         @(pos +098) dajccts(i)  $char2.
         @(pos +100) dajccns(i)  $char2.
         @(pos +102) dajccms(i)  $char2.
         @(pos +104) dajcstg(i)  $char2.
         @(pos +106) dss77s(i)   $char1.
         @(pos +107) dss00s(i)   $char1.
         @(pos +108) dajcflg(i)  $char1.
         @(pos +109) dss77f(i)   $char1.
         @(pos +110) dss00f(i)   $char1.
         @(pos +111) csvf(i)     $char6.
         @(pos +117) csvl(i)     $char6.
         @(pos +123) cscur(i)    $char6.
         @(pos +129) sxprif(i)   $char2.
         @(pos +131) sxscof(i)   $char1.
         @(pos +132) sxsitf(i)   $char1.
         @(pos +133) numnd(i)    $char2.
         @(pos +135) recstr(i)   $char1.
         @(pos +136) nosrg(i)    $char1.
         @(pos +137) rad(i)      $char1.
         @(pos +138) radbrn(i)   $char1.
         @(pos +139) radsurg(i)  $char1.
         @(pos +140) sssurg(i)   $char2.

         @(pos +142) sxscop(i)   $char1.
         @(pos +143) sxsite(i)   $char1.
         @(pos +146) ositage(i)  $char1.
         @(pos +147) oseqcon(i)  $char1.
         @(pos +148) oseqlat(i)  $char1.
         @(pos +149) osurcon(i)  $char1.
         @(pos +150) osittyp(i)  $char1.
         @(pos +151) hbenign(i)  $char1.
         @(pos +152) orptsrc(i)  $char1.
         @(pos +153) odfsite(i)  $char1.
         @(pos +154) oleukdx(i)  $char1.
         @(pos +155) ositbeh(i)  $char1.
         @(pos +156) oeoddt(i)   $char1.
         @(pos +157) ositeod(i)  $char1.
         @(pos +158) ositmor(i)  $char1.
         @(pos +159) typefu(i)   $char1.
         @(pos +160) ager(i)     $char2.
         @(pos +162) sterwho(i)  $char5.

         @(pos +171) icd09(i)    $char4.
         @(pos +175) icd10(i)    $char4.
         @(pos +179) ICCC3_WH(i) $char3.
         @(pos +182) ICC3X_WH(i) $char3.
         @(pos +185) behtrnd(i)  $char1.
         @(pos +186) histrecs(i) $char2.
         @(pos +188) hisrcb(i)   $char2.
         @(pos +190) cs04sch(i)  $char3.
         @(pos +193) hstst(i)    $char1.
         @(pos +194) ajccstg(i)  $char2.
         @(pos +196) aj3sr(i)    $char2.
         @(pos +198) sss77(i)    $char1.
         @(pos +199) sssm2z(i)   $char1.
         @(pos +200) frstprm(i)  $char1.
         @(pos +201) statecd(i)  $char2.
         @(pos +203) cnty(i)     $char3.
         @(pos +206) ihscd(i)    $char1.

         @(pos +207) sum2k(i)    $char1.
         @(pos +208) aya_who(i)  $char2.
         @(pos +210) lym_who(i)  $char2.
         @(pos +212) vsrtdx(i)   $char1.
         @(pos +213) odthcls(i)  $char1.
         @(pos +214) csts(i)     $char1.
         @(pos +215) csrg(i)     $char1.
         @(pos +216) csmt(i)     $char1.
         @(pos +217) intprims(i) $char1.
         @(pos +218) erstat(i)   $char1.
         @(pos +219) prstat(i)   $char1.
         @(pos +220) cssch(i)    $char2.
         @(pos +222) cssite8(i)  $char3.
         @(pos +225) cssite10(i) $char3.
         @(pos +228) cssite11(i) $char3.
         @(pos +231) cssite13(i) $char3.
         @(pos +234) cssite15(i) $char3.
         @(pos +237) cssite16(i) $char3.
         @(pos +240) vasinvv(i)  $char1.

/*  Public variables added in the 2014 Linkage  */
         @(pos +241) srvm(i)     $char4.
         @(pos +245) srvmflag(i) $char1.
/*         @(pos +246) filler      $char5.*/
         @(pos +251) insrecpb(i) $char1.
         @(pos +252) dajcc7ts(i) $char3.
         @(pos +255) dajcc7ns(i) $char3.
         @(pos +258) dajcc7ms(i) $char3.
         @(pos +261) dajcc7(i)   $char3.
         @(pos +264) adjajc6t(i) $char2.
         @(pos +266) adjajc6n(i) $char2.
         @(pos +268) adjajc6m(i) $char2.
         @(pos +270) adjajc6(i)  $char2.
         @(pos +272) cssite7(i)  $char3.
         @(pos +275) cssite9(i)  $char3.
         @(pos +278) cssite12(i) $char3.
         @(pos +281) her2rec(i)  $char1.
         @(pos +282) brstsub(i)  $char1.
         @(pos +283) anarbor(i)  $char1.

/*  Public variables added in the 2016 linkage */
         @(pos +284) csmetb(i)   $char1.
         @(pos +285) csmetbr(i)  $char1.
         @(pos +286) csmetliv(i) $char1.
         @(pos +287) csmetlun(i) $char1.
         @(pos +288) tvalue(i)   $char2.
         @(pos +290) nvalue(i)   $char2.
         @(pos +292) mvalue(i)   $char2.

/*  Not public but on PEDSF and released*/
         @(pos +294) ddxflg(i)   $char2.
         @(pos +296) dthflg(i)   $char2.
         @(pos +298) monrx(i)    $char2.
         @(pos +300) yr_rx(i)    $char4.
         @(pos +304) other_tx(i) $char1.
         @(pos +305) icdo(i)     $char1.
         @(pos +306) napia_cd(i) $char2.
         @(pos +308) payer_dx(i) $char2.

/*   Not public but on PEDSF, Special Permission Needed  */
         @(pos +310) onco_sc(i)  $char3.        /*Special Permission Needed*/
         @(pos +313) onco_rg(i)  $char1.        /*Special Permission Needed*/
         @(pos +314) onco_rns(i) $char1.        /*Special Permission Needed*/
         @(pos +315) onco_yr(i)  $char4.        /*Special Permission Needed*/
         @(pos +319) onco_mon(i) $char2.        /*Special Permission Needed*/
         @(pos +321) onco_tm(i)  $char3.        /*Special Permission Needed*/
         @;
     pos = pos + 324;
     end;
  input;


label
 /*  reg      = 'Registry'    */
 /*  casenum  = 'Case Number' */
  Patient_ID= 'Patient ID'
  fivepct  = 'Five Percent Indicator'
  mat_type = 'Match Type'
  yobflg1  = 'Year of Birth Flag'
  dobflg2  = 'Day of Birth Flag'
  yodflg3  = 'Year of Death Flag'
  sexflg4  = 'Sex Flag'
  lstflg5  = 'Last Name Flag'
  fstflg6  = 'First Name Flag'
  mobflg7  = 'Month of Birth Flag'
  midflg8  = 'Middle Initial Flag'
  numdigit = 'Number of Digits in SSN that Matched'
  dod_flg  = 'Date of Death Flag'
  dob_flg  = 'Date of Birth Flag'
  linkflag = 'Linkage Flag'
  med_dodm = 'Medicare Month of Death'
  med_dodd = 'Medicare Day of Death'
  med_dody = 'Medicare Year of Death'
  birthm   = 'Medicare Month of Birth'
  birthyr  = 'Medicare Year of Birth'
  m_sex    = 'Medicare Sex'
  race     = 'Medicare Race'
  rsncd1   = 'Original Reason for Entitlement'
  cur_ent  = 'Current Reason for Entitlment'
  cur_yr   = 'Current Reason for Entitlement Year'
  chr_esrd = 'Chronic Renal Disease'
  chr_esrd_yr = 'Chronic Renal Disease Year'
  first_esrd_yr = 'First Chronic Renal Disease Year'
  med_stcd = 'Medicare Status Code'
  medst_yr = 'Medicare Status Code Year'
  vrfydth  = 'Valid Date of Death'
  state    = 'State'
  county   = 'County'
  zip5     = 'Zip Code, first 5 characters'  /* Special Permission required for unencrypted zip */
  zip4     = 'Zip Code, last 4 characters'
  code_sys = 'Census Cod Sys 1970/80/90'
  tract1990= 'Census Tract 1970/1980/1990'
  tract2000= 'Census Tract 2000'
  tract2010= 'Census Tract 2010'
  hsa      = 'Health Service Area'
  urbrur   = 'Urban/Rural recode'
  urban    = 'Urban/Rural code'
  s_sex    = 'SEER Sex'
  rac_recb = 'Race recode (expanded 1970,80 exp rates)'
  rac_recy = 'Race recode (W, B, AI, API)'
  rac_reca = 'Race recode (White, Black, Other)'
  icd_code = 'COD ICD Code'
  cod89v   = 'Cause of Death (ICD-8 or 9)'
  cod10v   = 'Cause of Death (ICD-10)'
  codkm    = 'COD to site rec KM'
  codpub   = 'COD to site recode'
  nhiade   = 'NHIA Derived Hispanic Origin'
  ser_dodm = 'SEER Month of Death'
  ser_dody = 'SEER Year of Death'
  srace    = 'SEER Race/Ethnicity'
  origin   = 'Spanish surname or origin'
  origrecb = 'Origin recode NHIA (Hispanic, Non-Hisp)'
  STAT_REC = 'Vital status recode (study cutoff used)'
  cen_cert = 'Census Tract Certainty 70/80/90'
  ctcer2k  = 'Census Tract Certainty 2000'
  ctcer2010 = 'Census Tract Certainty 2010'
  census_pov_ind = 'Census Tract Poverty Indicator'
  yr_brth  = 'Year of Birth'
  dbrflag  = 'Date of Birth Flag'
  deathflag= 'Date Flag for Follow Up'
  count    = 'Number of SEER records'
  resnrec  = 'Diagnosis Indicator'
  oshufcase= 'Old Encrypted Casenum'

  plan07_01= "Plan-Value Indicators (January) (PartD - 2007)"
  plan08_01= "Plan-Value Indicators (January) (PartD - 2008)"
  plan09_01= "Plan-Value Indicators (January) (PartD - 2009)"
  plan10_01= "Plan-Value Indicators (January) (PartD - 2010)"
  plan11_01= "Plan-Value Indicators (January) (PartD - 2011)"
  plan12_01= "Plan-Value Indicators (January) (PartD - 2012)"
  plan13_01= "Plan-Value Indicators (January) (PartD - 2013)"
  plan14_01= "Plan-Value Indicators (January) (PartD - 2014)"
  dual07_01= "State Reported Dual Eligible Status Code (January) (PartD - 2007)"
  dual08_01= "State Reported Dual Eligible Status Code (January) (PartD - 2008)"
  dual09_01= "State Reported Dual Eligible Status Code (January) (PartD - 2009)"
  dual10_01= "State Reported Dual Eligible Status Code (January) (PartD - 2010)"
  dual11_01= "State Reported Dual Eligible Status Code (January) (PartD - 2011)"
  dual12_01= "State Reported Dual Eligible Status Code (January) (PartD - 2012)"
  dual13_01= "Stage Reported Dual Eligible Status Code (January) (PartD - 2013)"
  dual14_01= "State Reported Dual Eligible Status Code (January) (PartD - 2014)"
  ptd07    = "Plan Coverage Months (PartD - 2007)"
  ptd08    = "Plan Coverage Months (PartD - 2008)"
  ptd09    = "Plan Coverage Months (PartD - 2009)"
  ptd10    = "Plan Coverage Months (PartD - 2010)"
  ptd11    = "Plan Coverage Months (PartD - 2011)"
  ptd12    = "Plan Coverage Months (PartD - 2012)"
  ptd13    = "Plan Coverage Months (PartD - 2013)"
  ptd14    = "Plan Coverage Months (PartD - 2014)"
  dualcnt07= "Medicaid Dual Eligible Months (PartD - 2007)"
  dualcnt08= "Medicaid Dual Eligible Months (PartD - 2008)"
  dualcnt09= "Medicaid Dual Eligible Months (PartD - 2009)"
  dualcnt10= "Medicaid Dual Eligible Months (PartD - 2010)"
  dualcnt11= "Medicaid Dual Eligible Months (PartD - 2011)"
  dualcnt12= "Medicaid Dual Eligible Months (PartD - 2012)"
  dualcnt13= "Medicaid Dual Eligible Months (PartD - 2013)"
  dualcnt14= "Medicaid Dual Eligible Months (PartD - 2014)"
  mon1     = 'Part A and B Entitlement Monthly Indicator'
  gho1     = 'HMO Entitlement Monthly Indicator'
  allflag1 = 'State Buy-in Monthly Indicator'
  ptacnt1991 = 'Number of Months in 1991 Covered for Part A'
  ptacnt1992 = 'Number of Months in 1992 Covered for Part A'
  ptacnt1993 = 'Number of Months in 1993 Covered for Part A'
  ptacnt1994 = 'Number of Months in 1994 Covered for Part A'
  ptacnt1995 = 'Number of Months in 1995 Covered for Part A'
  ptacnt1996 = 'Number of Months in 1996 Covered for Part A'
  ptacnt1997 = 'Number of Months in 1997 Covered for Part A'
  ptacnt1998 = 'Number of Months in 1998 Covered for Part A'
  ptacnt1999 = 'Number of Months in 1999 Covered for Part A'
  ptacnt2000 = 'Number of Months in 2000 Covered for Part A'
  ptacnt2001 = 'Number of Months in 2001 Covered for Part A'
  ptacnt2002 = 'Number of Months in 2002 Covered for Part A'
  ptacnt2003 = 'Number of Months in 2003 Covered for Part A'
  ptacnt2004 = 'Number of Months in 2004 Covered for Part A'
  ptacnt2005 = 'Number of Months in 2005 Covered for Part A'
  ptacnt2006 = 'Number of Months in 2006 Covered for Part A'
  ptacnt2007 = 'Number of Months in 2007 Covered for Part A'
  ptacnt2008 = 'Number of Months in 2008 Covered for Part A'
  ptacnt2009 = 'Number of Months in 2009 Covered for Part A'
  ptacnt2010 = 'Number of Months in 2010 Covered for Part A'
  ptacnt2011 = 'Number of Months in 2011 Covered for Part A'
  ptacnt2012 = 'Number of Months in 2012 Covered for Part A'
  ptacnt2013 = 'Number of Months in 2013 Covered for Part A'
  ptacnt2014 = 'Number of Months in 2014 Covered for Part A'
  ptacnt2015 = 'Number of Months in 2015 Covered for Part A'
  ptbcnt1991 = 'Number of Months in 1991 Covered for Part B'
  ptbcnt1992 = 'Number of Months in 1992 Covered for Part B'
  ptbcnt1993 = 'Number of Months in 1993 Covered for Part B'
  ptbcnt1994 = 'Number of Months in 1994 Covered for Part B'
  ptbcnt1995 = 'Number of Months in 1995 Covered for Part B'
  ptbcnt1996 = 'Number of Months in 1996 Covered for Part B'
  ptbcnt1997 = 'Number of Months in 1997 Covered for Part B'
  ptbcnt1998 = 'Number of Months in 1998 Covered for Part B'
  ptbcnt1999 = 'Number of Months in 1999 Covered for Part B'
  ptbcnt2000 = 'Number of Months in 2000 Covered for Part B'
  ptbcnt2001 = 'Number of Months in 2001 Covered for Part B'
  ptbcnt2002 = 'Number of Months in 2002 Covered for Part B'
  ptbcnt2003 = 'Number of Months in 2003 Covered for Part B'
  ptbcnt2004 = 'Number of Months in 2004 Covered for Part B'
  ptbcnt2005 = 'Number of Months in 2005 Covered for Part B'
  ptbcnt2006 = 'Number of Months in 2006 Covered for Part B'
  ptbcnt2007 = 'Number of Months in 2007 Covered for Part B'
  ptbcnt2008 = 'Number of Months in 2008 Covered for Part B'
  ptbcnt2009 = 'Number of Months in 2009 Covered for Part B'
  ptbcnt2010 = 'Number of Months in 2010 Covered for Part B'
  ptbcnt2011 = 'Number of Months in 2011 Covered for Part B'
  ptbcnt2012 = 'Number of Months in 2012 Covered for Part B'
  ptbcnt2013 = 'Number of Months in 2013 Covered for Part B'
  ptbcnt2014 = 'Number of Months in 2014 Covered for Part B'
  ptbcnt2015 = 'Number of Months in 2015 Covered for Part B'
  hmocnt1991 = 'Number of Months in 1991 as an HMO member'
  hmocnt1992 = 'Number of Months in 1992 as an HMO member'
  hmocnt1993 = 'Number of Months in 1993 as an HMO member'
  hmocnt1994 = 'Number of Months in 1994 as an HMO member'
  hmocnt1995 = 'Number of Months in 1995 as an HMO member'
  hmocnt1996 = 'Number of Months in 1996 as an HMO member'
  hmocnt1997 = 'Number of Months in 1997 as an HMO member'
  hmocnt1998 = 'Number of Months in 1998 as an HMO member'
  hmocnt1999 = 'Number of Months in 1999 as an HMO member'
  hmocnt2000 = 'Number of Months in 2000 as an HMO member'
  hmocnt2001 = 'Number of Months in 2001 as an HMO member'
  hmocnt2002 = 'Number of Months in 2002 as an HMO member'
  hmocnt2003 = 'Number of Months in 2003 as an HMO member'
  hmocnt2004 = 'Number of Months in 2004 as an HMO member'
  hmocnt2005 = 'Number of Months in 2005 as an HMO member'
  hmocnt2006 = 'Number of Months in 2006 as an HMO member'
  hmocnt2007 = 'Number of Months in 2007 as an HMO member'
  hmocnt2008 = 'Number of Months in 2008 as an HMO member'
  hmocnt2009 = 'Number of Months in 2009 as an HMO member'
  hmocnt2010 = 'Number of Months in 2010 as an HMO member'
  hmocnt2011 = 'Number of Months in 2011 as an HMO member'
  hmocnt2012 = 'Number of Months in 2012 as an HMO member'
  hmocnt2013 = 'Number of Months in 2013 as an HMO member'
  hmocnt2014 = 'Number of Months in 2014 as an HMO member'
  hmocnt2015 = 'Number of Months in 2015 as an HMO member'
  stbuyin1991 = 'Number of Months in 1991 with State Buy-in Coverage'
  stbuyin1992 = 'Number of Months in 1992 with State Buy-in Coverage'
  stbuyin1993 = 'Number of Months in 1993 with State Buy-in Coverage'
  stbuyin1994 = 'Number of Months in 1994 with State Buy-in Coverage'
  stbuyin1995 = 'Number of Months in 1995 with State Buy-in Coverage'
  stbuyin1996 = 'Number of Months in 1996 with State Buy-in Coverage'
  stbuyin1997 = 'Number of Months in 1997 with State Buy-in Coverage'
  stbuyin1998 = 'Number of Months in 1998 with State Buy-in Coverage'
  stbuyin1999 = 'Number of Months in 1999 with State Buy-in Coverage'
  stbuyin2000 = 'Number of Months in 2000 with State Buy-in Coverage'
  stbuyin2001 = 'Number of Months in 2001 with State Buy-in Coverage'
  stbuyin2002 = 'Number of Months in 2002 with State Buy-in Coverage'
  stbuyin2003 = 'Number of Months in 2003 with State Buy-in Coverage'
  stbuyin2004 = 'Number of Months in 2004 with State Buy-in Coverage'
  stbuyin2005 = 'Number of Months in 2005 with State Buy-in Coverage'
  stbuyin2006 = 'Number of Months in 2006 with State Buy-in Coverage'
  stbuyin2007 = 'Number of Months in 2007 with State Buy-in Coverage'
  stbuyin2008 = 'Number of Months in 2008 with State Buy-in Coverage'
  stbuyin2009 = 'Number of Months in 2009 with State Buy-in Coverage'
  stbuyin2010 = 'Number of Months in 2010 with State Buy-in Coverage'
  stbuyin2011 = 'Number of Months in 2011 with State Buy-in Coverage'
  stbuyin2012 = 'Number of Months in 2012 with State Buy-in Coverage'
  stbuyin2013 = 'Number of Months in 2013 with State Buy-in Coverage'
  stbuyin2014 = 'Number of Months in 2014 with State Buy-in Coverage'
  stbuyin2015 = 'Number of Months in 2015 with State Buy-in Coverage'
  zip5_1991   = 'Zip Code in 1991, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1992   = 'Zip Code in 1992, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1993   = 'Zip Code in 1993, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1994   = 'Zip Code in 1994, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1995   = 'Zip Code in 1995, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1996   = 'Zip Code in 1996, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1997   = 'Zip Code in 1997, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1998   = 'Zip Code in 1998, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_1999   = 'Zip Code in 1999, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2000   = 'Zip Code in 2000, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2001   = 'Zip Code in 2001, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2002   = 'Zip Code in 2002, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2003   = 'Zip Code in 2003, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2004   = 'Zip Code in 2004, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2005   = 'Zip Code in 2005, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2006   = 'Zip Code in 2006, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2007   = 'Zip Code in 2007, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2008   = 'Zip Code in 2008, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2009   = 'Zip Code in 2009, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2010   = 'Zip Code in 2010, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2011   = 'Zip Code in 2011, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2012   = 'Zip Code in 2012, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2013   = 'Zip Code in 2013, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2014   = 'Zip Code in 2014, first 5 digits'  /* Special Permission required for unencypted zip */
  zip5_2015   = 'Zip Code in 2015, first 5 digits'  /* Special Permission required for unencypted zip */
  zip4_1991   = 'Zip Code in 1991, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1992   = 'Zip Code in 1992, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1993   = 'Zip Code in 1993, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1994   = 'Zip Code in 1994, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1995   = 'Zip Code in 1995, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1996   = 'Zip Code in 1996, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1997   = 'Zip Code in 1997, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1998   = 'Zip Code in 1998, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_1999   = 'Zip Code in 1999, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2000   = 'Zip Code in 2000, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2001   = 'Zip Code in 2001, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2002   = 'Zip Code in 2002, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2003   = 'Zip Code in 2003, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2004   = 'Zip Code in 2004, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2005   = 'Zip Code in 2005, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2006   = 'Zip Code in 2006, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2007   = 'Zip Code in 2007, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2008   = 'Zip Code in 2008, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2009   = 'Zip Code in 2009, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2010   = 'Zip Code in 2010, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2011   = 'Zip Code in 2011, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2012   = 'Zip Code in 2012, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2013   = 'Zip Code in 2013, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2014   = 'Zip Code in 2014, last 4 digits'  /* Special Permission required for unencypted zip */
  zip4_2015   = 'Zip Code in 2015, last 4 digits'  /* Special Permission required for unencypted zip */

  registry1991 ='SEER registry code in 1991 (retained over years)'
  registry1992 ='SEER registry code in 1992 (retained over years)'
  registry1993 ='SEER registry code in 1993 (retained over years)'
  registry1994 ='SEER registry code in 1994 (retained over years)'
  registry1995 ='SEER registry code in 1995 (retained over years)'
  registry1996 ='SEER registry code in 1996 (retained over years)'
  registry1997 ='SEER registry code in 1997 (retained over years)'
  registry1998 ='SEER registry code in 1998 (retained over years)'
  registry1999 ='SEER registry code in 1999 (retained over years)'
  registry2000 ='SEER registry code in 2000 (retained over years)'
  registry2001 ='SEER registry code in 2001 (retained over years)'
  registry2002 ='SEER registry code in 2002 (retained over years)'
  registry2003 ='SEER registry code in 2003 (retained over years)'
  registry2004 ='SEER registry code in 2004 (retained over years)'
  registry2005 ='SEER registry code in 2005 (retained over years)'
  registry2006 ='SEER registry code in 2006 (retained over years)'
  registry2007 ='SEER registry code in 2007 (retained over years)'
  registry2008 ='SEER registry code in 2008 (retained over years)'
  registry2009 ='SEER registry code in 2009 (retained over years)'
  registry2010 ='SEER registry code in 2010 (retained over years)'
  registry2011 ='SEER registry code in 2011 (retained over years)'
  registry2012 ='SEER registry code in 2012 (retained over years)'
  registry2013 ='SEER registry code in 2013 (retained over years)'
  registry2014 ='SEER registry code in 2014 (retained over years)'
  registry2015 ='SEER registry code in 2015 (retained over years)'

  reg2cd1991   = 'SEER registry code at the end of the year (1991)'
  reg2cd1992   = 'SEER registry code at the end of the year (1992)'
  reg2cd1993   = 'SEER registry code at the end of the year (1993)'
  reg2cd1994   = 'SEER registry code at the end of the year (1994)'
  reg2cd1995   = 'SEER registry code at the end of the year (1995)'
  reg2cd1996   = 'SEER registry code at the end of the year (1996)'
  reg2cd1997   = 'SEER registry code at the end of the year (1997)'
  reg2cd1998   = 'SEER registry code at the end of the year (1998)'
  reg2cd1999   = 'SEER registry code at the end of the year (1999)'
  reg2cd2000   = 'SEER registry code at the end of the year (2000)'
  reg2cd2001   = 'SEER registry code at the end of the year (2001)'
  reg2cd2002   = 'SEER registry code at the end of the year (2002)'
  reg2cd2003   = 'SEER registry code at the end of the year (2003)'
  reg2cd2004   = 'SEER registry code at the end of the year (2004)'
  reg2cd2005   = 'SEER registry code at the end of the year (2005)'
  reg2cd2006   = 'SEER registry code at the end of the year (2006)'
  reg2cd2007   = 'SEER registry code at the end of the year (2007)'
  reg2cd2008   = 'SEER registry code at the end of the year (2008)'
  reg2cd2009   = 'SEER registry code at the end of the year (2009)'
  reg2cd2010   = 'SEER registry code at the end of the year (2010)'
  reg2cd2011   = 'SEER registry code at the end of the year (2011)'
  reg2cd2012   = 'SEER registry code at the end of the year (2012)'
  reg2cd2013   = 'SEER registry code at the end of the year (2013)'
  reg2cd2014   = 'SEER registry code at the end of the year (2014)'
  reg2cd2015   = 'SEER registry code at the end of the year (2015)'

  state1991 = 'EDB state code at the end of the year (1991)'
  state1992 = 'EDB state code at the end of the year (1992)'
  state1993 = 'EDB state code at the end of the year (1993)'
  state1994 = 'EDB state code at the end of the year (1994)'
  state1995 = 'EDB state code at the end of the year (1995)'
  state1996 = 'EDB state code at the end of the year (1996)'
  state1997 = 'EDB state code at the end of the year (1997)'
  state1998 = 'EDB state code at the end of the year (1998)'
  state1999 = 'EDB state code at the end of the year (1999)'
  state2000 = 'EDB state code at the end of the year (2000)'
  state2001 = 'EDB state code at the end of the year (2001)'
  state2002 = 'EDB state code at the end of the year (2002)'
  state2003 = 'EDB state code at the end of the year (2003)'
  state2004 = 'EDB state code at the end of the year (2004)'
  state2005 = 'EDB state code at the end of the year (2005)'
  state2006 = 'EDB state code at the end of the year (2006)'
  state2007 = 'EDB state code at the end of the year (2007)'
  state2008 = 'EDB state code at the end of the year (2008)'
  state2009 = 'EDB state code at the end of the year (2009)'
  state2010 = 'EDB state code at the end of the year (2010)'
  state2011 = 'EDB state code at the end of the year (2011)'
  state2012 = 'EDB state code at the end of the year (2012)'
  state2013 = 'EDB state code at the end of the year (2013)'
  state2014 = 'EDB state code at the end of the year (2014)'
  state2015 = 'EDB state code at the end of the year (2015)'

  cnty1991 = 'EDB county code at the end of the year (1991)'
  cnty1992 = 'EDB county code at the end of the year (1992)'
  cnty1993 = 'EDB county code at the end of the year (1993)'
  cnty1994 = 'EDB county code at the end of the year (1994)'
  cnty1995 = 'EDB county code at the end of the year (1995)'
  cnty1996 = 'EDB county code at the end of the year (1996)'
  cnty1997 = 'EDB county code at the end of the year (1997)'
  cnty1998 = 'EDB county code at the end of the year (1998)'
  cnty1999 = 'EDB county code at the end of the year (1999)'
  cnty2000 = 'EDB county code at the end of the year (2000)'
  cnty2001 = 'EDB county code at the end of the year (2001)'
  cnty2002 = 'EDB county code at the end of the year (2002)'
  cnty2003 = 'EDB county code at the end of the year (2003)'
  cnty2004 = 'EDB county code at the end of the year (2004)'
  cnty2005 = 'EDB county code at the end of the year (2005)'
  cnty2006 = 'EDB county code at the end of the year (2006)'
  cnty2007 = 'EDB county code at the end of the year (2007)'
  cnty2008 = 'EDB county code at the end of the year (2008)'
  cnty2009 = 'EDB county code at the end of the year (2009)'
  cnty2010 = 'EDB county code at the end of the year (2010)'
  cnty2011 = 'EDB county code at the end of the year (2011)'
  cnty2012 = 'EDB county code at the end of the year (2012)'
  cnty2013 = 'EDB county code at the end of the year (2013)'
  cnty2014 = 'EDB county code at the end of the year (2014)'
  cnty2015 = 'EDB county code at the end of the year (2015)'

  reg1    = 'Registry ID'
  marst1  = 'Marital Status at DX'
  agedx1  = 'Age at Diagnosis'
  seq1    = 'Sequence at Diagnosis'
  modx1   = 'Month of Diagnosis'
  yrdx1   = 'Year of Diagnosis'
  site1   = 'Primary Site'
  lat1    = 'Laterality'
  hist2_1 = 'Histology (92-00) ICD-O-2'
  beh2_1  = 'Behavior (92-00) ICD-O-2'
  hist1   = 'Histologic Type ICD-O-3'
  beh1    = 'Behavior Code ICD-O-3'
  grade1  = 'Grade'
  dxconf1 = 'Diagnostic Confirmation'
  src1    = 'Type of Reporting Source'
  e10sz1  = 'EOD 10 - Tumor Size'
  e10ex1  = 'EOD 10 - Extension'
  e10pe1  = 'EOD 10 - Extension Prostate Path'
  e10nd1  = 'EOD 10 - Lymph Node Involement'
  e10pn1  = 'EOD 10 - Regional Nodes Postive'
  e10ne1  = 'EOD 10 - Regional Nodes Examined'
  e13_1_1 = 'EOD -- OLD 13 Digit (First digit)'
  e13_2_1 = 'EOD -- OLD 13 Digit (Second digit)'
  e13_3_1 = 'EOD -- OLD 13 Digit (Third digit)'
  e13_4_1 = 'EOD -- OLD 13 Digit (Fourth digit)'
  e13_5_1 = 'EOD -- OLD 13 Digit (Fifth digit)'
  e13_6_1 = 'EOD -- OLD 13 Digit (sixth digit)'
  e13_7_1 = 'EOD -- OLD 13 Digit (Seventh digit)'
  e13_8_1 = 'EOD -- OLD 13 Digit (Eighth digit)'
  e13_9_1 = 'EOD -- OLD 13 Digit (Nineth digit)'
  e13_10_1= 'EOD -- OLD 13 Digit (Tenth digit)'
  e13_11_1= 'EOD -- OLD 13 Digit (Eleventh digit)'
  e13_12_1= 'EOD -- OLD 13 Digit (Twelvth digit)'
  e13_13_1= 'EOD -- OLD 13 Digit (Thirteenth digit)'
  e2_1_1  = 'EOD -- OLD 2 Digit (First Digit)'
  e2_2_1  = 'EOD -- OLD 2 Digit (Second Digit)'
  e4siz1  = 'EOD -- OLD 4 Digit (First Two Digits)'
  e4ext1  = 'EOD -- OLD 4 Digit (Third Digit)'
  e4nod1  = 'EOD -- OLD 4 Digit (Fourth Digit)'
  eod_cd1 = 'Coding System for EOD'
  tumor1_1= 'Tumor Marker 1'
  tumor2_1= 'Tumor Marker 2'
  tumor3_1= 'Tumor Marker 3'
  cstum1  = 'CS Tumor Size'
  csex1   = 'CS Extension'
  cslym1  = 'CS Lymph Nodes'
  csmet1  = 'CS Mets at DX'
  cs1st1  = 'CS Site-Specific Factor 1'
  cs2st1  = 'CS Site-Specific Factor 2'
  cs3st1  = 'CS Site-Specific Factor 3'
  cs4st1  = 'CS Site-Specific Factor 4'
  cs5st1  = 'CS Site-Specific Factor 5'
  cs6st1  = 'CS Site-Specific Factor 6'
  cs25st1 = 'CS Site-Specific Factor 25'
  dajcct1 = 'Derived AJCC T'
  dajccn1 = 'Derived AJCC N'
  dajccm1 = 'Derived AJCC M'
  dajccstg1='Derived AJCC Stage Group'
  dss77s1 = 'Derived SS1977'
  dss00s1 = 'Derived SS2000'
  dajcflg1= 'Derived AJCC - Flag'
  dss77f1 = 'Derived SS1977 - Flag'
  dss00f1 = 'Derived SS2000 - Flag'
  csvf1   = 'CS Version Input Original'
  csvl1   = 'CS Version Derived'
  cscurrent1= 'CS Version Input Current'
  sxprif1 = 'RX Summ--Surg Prim Site'
  sxscof1 = 'RX Summ--Scope Reg LN Sur'
  sxsitf1 = 'RX Summ--Surg Oth Reg/Dis'
  numnd1  = 'RX Summ--Reg LN Examined'
  recstr1 = 'RX Summ--Reconstruct 1st'
  nosrg1  = 'Reason for no surgery'
  rad1    = 'RX Summ--Radiation'
  radbrn1 = 'RX Summ--Rad to CNS'
  radsurg1= 'RX Summ--Surg/Rad Seq'
  sssurg1 = 'RX Summ--Surgery Type'
  sxscop1 = 'RX Summ--Scope Reg 98-02'
  sxsite1 = 'RX Summ--Surg Oth 98-02'
  ositage1= 'Over-ride age/site/morph'
  oseqcon1= 'Over-ride seqno/dxconf'
  oseqlat1= 'Over-ride site/lat/seqno'
  osurcon1= 'Over-ride surg/dxconf'
  osittyp1= 'Over-ride site/type'
  hbenign1= 'Over-ride histology'
  orptsrc1= 'Over-ride report source'
  odfsite1= 'Over-ride ill-define site'
  oleukdx1= 'Over-ride Leuk, Lymph'
  ositbeh1= 'Over-ride site/behavior'
  oeoddt1 = 'Over-ride site/eod/dx dt'
  ositeod1= 'Over-ride site/lat/eod'
  ositmor1= 'Over-ride site/lat/morph'
  typefu1 = 'SEER Typeof followup'
  ager1   = 'Age Recode <1 Year olds'
  siterwho1= 'Site recode ICD-O-3/WHO 2008'
  icdot09_1= 'Recode ICD-O-2 to 9'
  icdot10_1= 'Recode ICD-O-2 to 10'
  iccc3who1= 'ICCC site recode ICD-O-3/WHO2008'
  icc3xwho1= 'ICCC site rec. extended ICD-O-3/WHO 2008'
  behtrend1= 'Behavior Recode for Analysis'
  histrec1 = 'Histology Recode--Broad Groupings'
  hisrcb1  = 'Histology Recode--Brain Groupings'
  cs04sch1 = 'CS Schema v0204'
  hstst1   = 'SEER Historic Stage A'
  ajccstg1 = 'AJCC Stage 3rd edition (1988-2003)'
  aj3sr1   = 'SEER modified AJCC stage 3rd ed'
  sss77v1  = 'SEER Summary Stage 1977 (1995-2000)'
  frstprm1 = 'First malignant primary indicator'
  statecd1 = 'State Code'
  cnty1    = 'County code'
  ihscd1   = 'IHS Link'
  summ2k1  = 'Summary Stage 2000 (1998+)'
  ayawho1  = 'AYA site recode/WHO 2008'
  lymwho1  = 'Lymphoma subtype recode/WHO 2008'
  vsrtdx1  = 'SEER Cause-Specific Death Classification'
  odthclass1= 'SEER Other Cause of Death Classification'
  csts1    = 'CS Tumor Size/Ext Eval'
  csrg1    = 'CS Lymph Nodes Eval'
  csmt1    = 'CS Mets Eval'
  intprim1 = 'Primary by international rules'
  erstat1  = 'ER Status Recode Breast Cancer'
  prstat1  = 'PR Status Recode Breat Cancer'
  cssch1   = 'CS Schema - AJCC 6th ed(previously called v1)'
  cs8st1   = 'CS Site-Specific Factor 8'
  cs10st1  = 'CS Site-Specific Factor 10'
  cs11st1  = 'CS Site-Specific Factor 11'
  cs13st1  = 'CS Site-Specific Factor 13'
  cs15st1  = 'CS Site-Specific Factor 15'
  cs16st1  = 'CS Site-Specific Factor 16'
  vasinv1  = 'Lymph-vascular Invasion (2004+)'
  srvm1    = 'Survival Months'
  srvmflag1= 'Survival Months Flag'
  insrecpb1= 'Insurance Recode (2007+)'
  dajcc7t1 = 'Derived AJCC T 7th ed'
  dajcc7n1 = 'Derived AJCC N 7th ed'
  dajcc7m1 = 'Derived AJCC M 7th ed'
  dajcc7_01= 'Derived AJCC 7 Stage Group'
  adjajc6t1= 'Adjusted AJCC 6th T with mets (1988+)'
  adjajc6n1= 'Adjusted AJCC 6th N with mets (1988+)'
  adjajc6m1= 'Adjusted AJCC 6th m with mets (1988+)'
  adjajc6_01='Adjusted AJCC 6th Stage (1988+)'
  cs7st1   = 'CS Site-Specific Factor 7'
  cs9st1   = 'CS Site-Specific Factor 9'
  cs12st1  = 'CS Site-Specific Factor 12'
  her2rec1 = 'Derived HER2 Recode (2010+)'
  brstsub1 = 'Breast Subtype (2010+)'
  annarbor1= 'Lymphoma - Ann Arbor Stage (1983+)'

  csmetsdxb_pub1 ='CS mets a DX-bone'
  csmetsdxbr_pub1='CS mets a DX-brain'
  csmetsdxliv_pub1='CS mets a DX-liver'
  csmetsdxlung_pub1='CS mets a DX-lung'
  t_value1='T value - based on AJCC 3rd (1988-2002)'
  n_value1='N value - based on AJCC 3rd (1988-2002)'
  m_value1='M value - based on AJCC 3rd (1988-2002)'

  ddxflag1 = 'Diagnosis Date Flag'
  dthflag1 = 'Therapy Date Flag'
  monrx1   = 'Month Therapy Started'
  yearrx1  = 'Year Therapy Started'
  other_tx1= 'Other Therapy'
  icdo1    = 'ICD-O Coding Scheme'
  napiia1  = 'NAPIIA Derived API Race'
  payer_dx1= 'Primary Payer at DX'

  onco_score1 = "OncoType Dx recurrence score"
  onco_rg1 = "OncoType DX risk group"
  onco_rns1 = "OncoType DX reason no score"
  onco_year1 = "OncoType DX delivered year"
  onco_month1 = "OncoType DX delivered month"
  onco_time1 = "OncoType DX months since diagnosis"

  ;

run;

proc contents data=pedsf06;
   title 'proc contents, of PEDSF file';

run;
