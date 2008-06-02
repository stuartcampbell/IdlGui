PRO miniMakeGuiReduceNormalizationBase, Event, REDUCE_BASE, IndividualBaseWidth

;yes or not base
NormalizationYesNoBaseSize = [0,155,IndividualBaseWidth,30]

;yes or not offset
NormalizationBGroupLabelSize = [10,5]
NormalizationBGroupLabelTitle = 'N O R M A L I Z A T I O N:'
NormalizationBGroupList = [' Yes    ',' No    ']
d1=190
NormalizationBGroupSize = [NormalizationBGroupLabelSize[0]+d1,$
                           NormalizationBGroupLabelSize[1]-5]

;size of Norm base
NormalizationBaseSize   = [0, $
                           NormalizationYesNoBaseSize[1]+30,$
                           IndividualBaseWidth, $
                           155]

;frame
Yoffset= 0
NormalizationLabelSize  = [20,2+Yoffset]
NormalizationLabelTitle = 'N O R M A L I Z A T I O N'
NormalizationFrameSize  = [10,10+Yoffset,IndividualBaseWidth-30,135]

;runs number
RunsLabelSize     = [15,27+Yoffset]
RunsLabelTitle    = 'Runs:'
d_L_T = 40
RunsTextFieldSize = [RunsLabelSize[0]+d_L_T,$
                     RunsLabelSize[1]-5,498,30]

d_vertical_L_L = 30
;region of interest 
RegionOfInterestLabelSize = [RunsLabelSize[0],$
                             RunsLabelSize[1]+d_vertical_L_L]
RegionOfInterestLabelTitle = 'Region of interest (ROI) file:'
RegionOfInterestTextFieldSize = [210,$
                                 RegionOfInterestLabelSize[1]-5,$
                                 300,30]
              
;Exclusion peak region / Background -------------------------------------------

XYoff = [0,52] ;Peak Base and labels
sPeakBase = { size:  [RunsLabelSize[0]+XYoff[0],$
                      RunsLabelSize[1]+XYoff[1],$
                      500,30],$
              frame: 0,$
              uname: 'norm_peak_base',$
              map:   1}

XYoff = [0,7] ;Main label
sPeakMainLabel = { size:  XYoff,$
                   value: 'Peak Exclusion Region:'}
XYoff = [200,0]
sPeakYminLabel = { size: [sPeakMainLabel.size[0]+XYoff[0],$
                          sPeakMainLabel.size[1]+XYoff[1]],$
                   value: 'Ymin:'}
XYoff = [50,0]
sPeakYminValue = { size: [sPeakYminLabel.size[0]+XYoff[0],$
                          sPeakYminLabel.size[1]+XYoff[1],$
                          50],$
                   value: '',$
                   uname: 'norm_exclusion_low_bin_text'}
XYoff = [100,0]
sPeakYmaxLabel = { size: [sPeakYminValue.size[0]+XYoff[0],$
                          sPeakYminValue.size[1]+XYoff[1]],$
                   value: 'Ymax:'}
XYoff = [50,0]
sPeakYmaxValue = { size: [sPeakYmaxLabel.size[0]+XYoff[0],$
                          sPeakYmaxLabel.size[1]+XYoff[1],$
                          50],$
                   value: '',$
                   uname: 'norm_exclusion_high_bin_text'}

;Background Base, label and text_field
sBackBase = { size:  sPeakBase.size,$
              frame: 0,$
              uname: 'norm_background_base',$
              map:   0}

XYoff = [0,7]                   ;Main label
sBackMainLabel = { size:  XYoff,$
                   value: 'Background Selection File:'}
XYoff = [170,0]
sBackFileValue = { size: [sBackMainLabel.size[0]+XYoff[0],$
                          sBackMainLabel.size[1]+XYoff[1]],$
                   value: '',$
                   uname: 'norm_back_selection_file_value'}

;Background Flag  
XYoff = [0,7]             
BackgroundLabelSize = [sPeakBase.size[0]+XYoff[0],$
                       sPeakBase.size[1]+sPeakBase.size[3]+XYoff[1]]
BackgroundLabelTitle = 'Background:'
d_L_T_3 = 100
BackgroundBGroupSize = [BackgroundLabelSize[0]+d_L_T_3,$
                        BackgroundLabelSize[1]-5]
BackgroundBGroupList = [' Yes    ',' No    ']

;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

NormalizationYesNoBase = $
  WIDGET_BASE(REDUCE_BASE,$
              XOFFSET   = NormalizationYesNoBaseSize[0],$
              YOFFSET   = NormalizationYesNoBaseSize[1],$
              SCR_XSIZE = NormalizationYesNoBaseSize[2],$
              SCR_YSIZE = NormalizationyesNoBaseSize[3])
                                     
;normalization yes or no
NormalizationBGroupLabel = $
  WIDGET_LABEL(NormalizationYesNoBase,$
               XOFFSET = NormalizationBGroupLabelSize[0],$
               YOFFSET = NormalizationBGroupLabelSize[1],$
               VALUE   = NormalizationBGroupLabelTitle)

NormalizationBGroup = $
  CW_BGROUP(NormalizationYesNoBase,$
            NormalizationBGroupList,$
            XOFFSET   = NormalizationBGroupSize[0],$
            YOFFSET   = NormalizationBGroupSize[1],$
            ROW       = 1,$
            UNAME     = 'yes_no_normalization_bgroup',$
            SET_VALUE = 0,$
            /EXCLUSIVE)

;base
normalization_base = WIDGET_BASE(REDUCE_BASE,$
                                 UNAME     = 'normalization_base',$
                                 XOFFSET   = NormalizationBaseSize[0],$
                                 YOFFSET   = NormalizationBaseSize[1],$
                                 SCR_XSIZE = NormalizationBaseSize[2],$
                                 SCR_YSIZE = NormalizationBaseSize[3])

;Normalization main label
NormalizationLabel = WIDGET_LABEL(normalization_base,$
                                  XOFFSET = NormalizationLabelSize[0],$
                                  YOFFSET = NormalizationLabelSize[1],$
                                  VALUE   = NormalizationLabelTitle)

;runs label
RunsLabel = WIDGET_LABEL(normalization_base,$
                         XOFFSET = RunsLabelSize[0],$
                         YOFFSET = RunsLabelSize[1],$
                         VALUE   = RunsLabelTitle)

;runs text field
RunsTextField = WIDGET_TEXT(normalization_base,$
                            XOFFSET   = RunsTextFieldSize[0],$
                            YOFFSET   = RunsTextFieldSize[1],$
                            SCR_XSIZE = RunsTextFieldSize[2],$
                            SCR_YSIZE = RunsTextFieldSize[3],$
                            UNAME     = 'reduce_normalization_runs_text_field',$
                            /editable,$
                            /ALIGN_LEFT,$
                            /all_events)

;region of interest label
RegionOfInterestLabel = WIDGET_LABEL(normalization_base,$
                                     XOFFSET = RegionOfInterestLabelSize[0],$
                                     YOFFSET = RegionOfInterestLabelSize[1],$
                                     VALUE   = RegionOfInterestLabelTitle)

;region of interest text field
RegionOfInterestTextField = $
  WIDGET_LABEL(normalization_base,$
               XOFFSET   = RegionOfInterestTextFieldSize[0],$
               YOFFSET   = RegionOfInterestTextFieldSize[1],$
               SCR_XSIZE = RegionOfInterestTextFieldSize[2],$
               UNAME     = 'reduce_normalization_region_of_interest_file_name',$
               /ALIGN_LEFT,$
               VALUE     = '')

;Peak exlusion Base -----------------------------------------------------------
wPeakBase = WIDGET_BASE(normalization_base,$
                        XOFFSET   = sPeakBase.size[0],$
                        YOFFSET   = sPeakBase.size[1],$
                        SCR_XSIZE = sPeakBase.size[2],$
                        SCR_YSIZE = sPeakBase.size[3],$
                        FRAME     = sPeakBase.frame,$
                        UNAME     = sPeakBase.uname,$
                        MAP       = sPeakBase.map)

wPeakMainLabel = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakMainLabel.size[0],$
                              YOFFSET = sPeakMainLabel.size[1],$
                              VALUE   = sPeakMainLabel.value)
                              
wPeakYminLabel = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakYminLabel.size[0],$
                              YOFFSET = sPeakYminLabel.size[1],$
                              VALUE   = sPeakYminLabel.value)

wPeakYminValue = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakYminValue.size[0],$
                              YOFFSET = sPeakYminValue.size[1],$
                              VALUE   = sPeakYminValue.value)

wPeakYmaxLabel = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakYmaxLabel.size[0],$
                              YOFFSET = sPeakYmaxLabel.size[1],$
                              VALUE   = sPeakYmaxLabel.value)

wPeakYmaxValue = WIDGET_LABEL(wPeakBase,$
                              XOFFSET = sPeakYmaxValue.size[0],$
                              YOFFSET = sPeakYmaxValue.size[1],$
                              VALUE   = sPeakYmaxValue.value)

;Background exlusion Base -----------------------------------------------------
wBackBase = WIDGET_BASE(normalization_base,$
                        XOFFSET   = sBackBase.size[0],$
                        YOFFSET   = sBackBase.size[1],$
                        SCR_XSIZE = sBackBase.size[2],$
                        SCR_YSIZE = sBackBase.size[3],$
                        FRAME     = sBackBase.frame,$
                        UNAME     = sBackBase.uname,$
                        MAP       = sBackBase.map)

wBackMainLabel = WIDGET_LABEL(wBackBase,$
                              XOFFSET = sBackMainLabel.size[0],$
                              YOFFSET = sBackMainLabel.size[1],$
                              VALUE   = sBackMainLabel.value)

wBackFileValue = WIDGET_LABEL(wBackBase,$
                              XOFFSET = sBackFileValue.size[0],$
                              YOFFSET = sBackFileValue.size[1],$
                              VALUE   = sBackFileValue.value,$
                              UNAME   = sBackFileValue.uname,$
                              /ALIGN_LEFT)

;background
BackgroundLabel = WIDGET_LABEL(normalization_base,$
                               XOFFSET = BackgroundLabelSize[0],$
                               YOFFSET = BackgroundLabelSize[1],$
                               VALUE   = BackgroundLabelTitle)

BackgroundBGroup = CW_BGROUP(normalization_base,$
                             BackgroundBGroupList,$
                             XOFFSET   = BackgroundBGroupSize[0],$
                             YOFFSET   = BackgroundBGroupSize[1],$
                             SET_VALUE = 0,$
                             UNAME     = 'normalization_background_cw_bgroup',$
                             ROW       = 1,$
                             /EXCLUSIVE)    

;frame
NormalizationFrame = WIDGET_LABEL(normalization_base,$
                         XOFFSET   = NormalizationFrameSize[0],$
                         YOFFSET   = NormalizationFrameSize[1],$
                         SCR_XSIZE = NormalizationFrameSize[2],$
                         SCR_YSIZE = NormalizationFrameSize[3],$
                         FRAME     = 1,$
                         VALUE='')

END
