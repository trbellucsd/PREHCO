* Encoding: UTF-8.


*Pull variables from original file. 
DATASET ACTIVATE DataSet14.
  SAVE OUTFILE='L:\frailityitems.SAV' /KEEP=
  caseid
  g110d
  wg110d
  u7_S
  wu8e
  wu11e_2
  wu11e_3
  u6_1
  wu7e
  g161
  wg161
  g162
  wg162
  g31
  wg31
  g22
  wg22
  g8
  wg8
  g4
  wg4
  g35
  wg35
  g36
  wg36
  g40
  wg40
  g62
  wg62
  i13
  wi13
  g110g
  wg110g
  g183
  wg183
  .
  
*Recode data to clean it (i.e., all missing codes to sysmis and change 2 to = 0 for Yes/No variables). 
DATASET ACTIVATE DataSet19.
RECODE lost10lb_w1 lost10lb_w2 getup_w1 getup_w2 grip_1_w2 grip_2_w2 legstand_w1 legstand_w2 
    smoke100_w1 smoke100_w2 smokenow_w1 smokenow_w2 osteo_w1 osteo_w2 walkdiff_w1 walkdiff_w2 
    easilyfatigued_w1 easilyfatigued_w2 fullenergy_w1 fullenergy_w2 (Lowest thru -9=SYSMIS).
EXECUTE.

RECODE lost10lb_w1 lost10lb_w2 getup_w1 getup_w2 grip_1_w2 grip_2_w2 legstand_w1 legstand_w2 
    smoke100_w1 smoke100_w2 smokenow_w1 smokenow_w2 osteo_w1 osteo_w2 walkdiff_w1 walkdiff_w2 
    easilyfatigued_w1 easilyfatigued_w2 fullenergy_w1 fullenergy_w2 (-5=SYSMIS) (Lowest thru -9=SYSMIS).    
EXECUTE.

RECODE lost10lb_w1 lost10lb_w2 smoke100_w1 smoke100_w2 smokenow_w1 smokenow_w2 osteo_w1 osteo_w2 
    walkdiff_w1 walkdiff_w2 easilyfatigued_w1 easilyfatigued_w2 fullenergy_w1 fullenergy_w2 (2=0).
EXECUTE.

DATASET ACTIVATE DataSet20.
RECODE fullenergy_w1 fullenergy_w2 legstand_w1 legstand_w2 (0=1) (1=0) INTO fullenergy_w1r fullenergy_w2r legstand_w1r legstand_w2r.
EXECUTE.

*Calculate Comorbidity scores.
COMPUTE COMORB_w1=sum(osteo_w1, lungdisease_w1, cancer_w1, diab_w1, htn_w1, MI_w1, CHF_w1, stroke_w1). 
COMPUTE COMORB_w2 =sum(osteo_w2, lungdisease_w2, cancer_w2, diab_w2, htn_w2, MI_w2, CHF_w2, stroke_w2).

*Compute Frail Scores. 
COMPUTE FRAIL_W1 = SUM(lost10lb_w1, getup_w1cat, walkdiff_w1, easilyfatigued_w1, legstand_w1r).
COMPUTE FRAIL_W2 = SUM(lost10lb_w2, getup_w2cat, walkdiff_w2, easilyfatigued_w2, legstand_w2r).
COMPUTE FRAIL_W2_grip = SUM(lost10lb_w2, getup_w2cat, walkdiff_w2, easilyfatigued_w2, legstand_w2r, grip_1_w2cat).


*Run factor analyses for each wave. 
  FACTOR
  /VARIABLES lost10lb_w1 getup_w1cat walkdiff_w1 easilyfatigued_w1 legstand_w1r
  /MISSING LISTWISE 
  /ANALYSIS lost10lb_w1 getup_w1cat walkdiff_w1 easilyfatigued_w1 legstand_w1r
  /PRINT INITIAL EXTRACTION ROTATION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /METHOD=CORRELATION.


  FACTOR
  /VARIABLES lost10lb_w2 getup_w2cat walkdiff_w2 easilyfatigued_w2 legstand_w2r grip_1_w2cat
  /MISSING LISTWISE 
  /ANALYSIS lost10lb_w2 getup_w2cat walkdiff_w2 easilyfatigued_w2 legstand_w2r grip_1_w2cat
  /PRINT INITIAL EXTRACTION ROTATION
  /CRITERIA MINEIGEN(1) ITERATE(25)
  /EXTRACTION PC
  /CRITERIA ITERATE(25)
  /ROTATION VARIMAX
  /METHOD=CORRELATION.

*Make change scores.

COMPUTE FRAILCHANGE=FRAIL_w2-FRAIL_w1.
EXECUTE.
COMPUTE IADLCHANGE=IADLTOT_w2-IADLTOT_w1.
EXECUTE.
COMPUTE COMORBCHANGE=COMORB_w2-COMORB_w1.
EXECUTE.
