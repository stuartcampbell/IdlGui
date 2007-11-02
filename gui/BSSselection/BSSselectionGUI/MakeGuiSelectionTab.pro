PRO MakeGuiSelectionTab, MAIN_TAB, MainTabSize, SelectionTitle, XYfactor

;***********************************************************************************
;                             Define size arrays
;***********************************************************************************

;Message box
MessageTextSize = [755,247,430,30]

CountsVsTofLabelSize  = [890,290]
CountsVsTofLabelTitle = ' C O U N T S   vs   T O F'

CountsVsTofSize = [755,$
                   CountsVsTofLabelSize[1]+20,$
                   430,$
                   225]

;X, Y, PixelID and Bank of data display in counts vs tof
CountsVsTofXLabelSize = [750, $
                         CountsVsTofLabelSize[1]+242, $
                         100, $
                         30]
xoff = 100
CountsVsTofYLabelSize = [CountsVsTofXLabelSize[0]+xoff,$
                         CountsVsTofXLabelSize[1:3]]
CountsVsTofBankLabelSize = [CountsVsTofXLabelSize[0]+2*xoff,$
                            CountsVsTofXLabelSize[1:3]]
xoff = 105
CountsVsTofPixelLabelSize = [CountsVsTofXLabelSize[0]+3*xoff,$
                             CountsVsTofXLabelSize[1:3]]

CountsVsTofFrameSize = [748,CountsVsTofLabelSize[1]-5,440,275]

OpenNeXusSelectionTab = [755,5,425,210]
OpenNeXusTitle        = ' NEXUS / ROI '
SelectionTitle        = '  SELECTION  '

XYPixelIDBaseSize     = [80,330,580,35]
xbaseSize             = [0,0,55,35]
xoff = 60
ybasesize             = [xbaseSize[0]+xoff,$
                         xbaseSize[1],$
                         xbaseSize[2],$
                         xbaseSize[3]]
xoff = 60
bankBaseSize          = [ybaseSize[0]+xoff,$
                         xbaseSize[1],$
                         65,$
                         xbaseSize[3]]
xoff = 70
rowBaseSize           = [bankbaseSize[0]+xoff,$
                         xbaseSize[1],$
                         80,$
                         xbaseSize[3]]
xoff = 75
tubeBaseSize          = [rowBaseSize[0]+xoff,$
                         xbaseSize[1],$
                         80,$
                         xbaseSize[3]]
xoff = 80
pixelIDbaseSize       = [tubeBaseSize[0]+xoff,$
                         xbaseSize[1],$
                         110,$
                         xbaseSize[3]]
xoff = 110
countsBaseSize        = [pixelIDbasesize[0]+xoff,$
                         xbaseSize[1],$
                         150,$
                         xbaseSize[3]]

Xfactor = XYfactor.Xfactor 
Yfactor = XYfactor.Yfactor
TopBankSize    = [15, $
                  5, $
                  56*Xfactor, $
                  64*Yfactor]
BottomBankSize = [TopBankSize[0], $
                  375, $
                  TopBankSize[2], $
                  TopBanksize[3]]

;COLOR SELECTION and MAIN_PLOT BASE
ColorBaseSize       = [748,565,440,135]
ColorLabelSize      = [ 115,5,200,0]

SelectionDropListSize = [0,30,80,30]
SelectionDropList     = ['Grid: Vertical Lines', $
                         'Grid: Horizontal Lines',$
                         'Excluded pixels',$
                         'Main Plot']

ResetColorButtonSize       = [190,32,80,30]
ResetColorButtonTitle      = 'R E S E T'

FullResetColorButtonSize   = [280,32,150,30]
FullResetColorButtonTitle  = 'F U L L  R E S E T'

ColorSliderBaseSize   = [10,65,415,45]
ColorSliderLabelSize  = [13,0,420,30]
ColorSliderLabelTitle = 'Black       Green      Red        Pink       Purple       White'
ColorSliderSize       = [10,25,390,20]
LoadctDropListSize    = [120,15,300,30]
LoadctList = ['Black/White Linear',$
              'Blue/White',$
              'Green/Red/Blue/White',$
              'Red Temperature',$
              'Blue/Green/Red/Yellow',$
              'Std Gamma-II',$
              'Prism',$
              'Red/Purple',$
              'Green/White Linear',$
              'Green/White Exponential',$
              'Green/Pink',$
              'Blue/Red',$
              '16 Level',$
              'Rainbow',$
              'Steps',$
              'Stern Special',$
              'Haze',$
              'Blue/Pastel/Red',$
              'Pastels',$
              'Hue Sat Lightness 1',$
              'Hue Sat Lightness 2',$
              'Hue Sat Value 1',$
              'Hue Sat Value 2',$
              'Purple/Red + Stripes',$
              'Beach',$
              'Mac Style',$
              'Eos A',$
              'Eos B',$
              'Hardcandy',$
              'Nature',$
              'Ocean',$
              'Peppermint',$
              'Plasma',$
              'Blue/Red',$
              'Rainbow',$
              'Blue Waves',$
              'Volcano',$
              'Waves',$
              'Rainbow 18',$
              'Rainbow + White',$
              'Rainbow + Black']

;***********************************************************************************
;                                Build GUI
;***********************************************************************************

SelectionBase = WIDGET_BASE(MAIN_TAB,$
                            XOFFSET   = 0,$
                            YOFFSET   = 0,$
                            SCR_XSIZE = MainTabSize[2],$
                            SCR_YSIZE = MainTabSize[3],$
                            TITLE     = SelectionTitle)

;Message box
MessageText = WIDGET_TEXT(SelectionBase,$
                          XOFFSET   = MessageTextSize[0],$
                          YOFFSET   = MessageTextSize[1],$
                          SCR_XSIZE = MessageTextsize[2],$
                          SCR_YSIZE = MessageTextSize[3],$
                          UNAME     = 'message_text',$
                          /ALIGN_LEFT)

;COUNTS VS TOF
counts_vs_tof_label = WIDGET_LABEL(SelectionBase,$
                                   XOFFSET = CountsVsTofLabelSize[0],$
                                   YOFFSET = CountsVsTofLabelSize[1],$
                                   VALUE   = CountsVsTofLabelTitle)

COUNTS_VS_TOF = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'counts_vs_tof_draw',$
                            XOFFSET   = CountsVsTofSize[0],$
                            YOFFSET   = CountsVsTofSize[1],$
                            SCR_XSIZE = CountsVsTofSize[2],$
                            SCR_YSIZE = CountsVsTofSize[3],$
                            /MOTION_EVENTS,$
                            /BUTTON_EVENTS)

CountsVsTofXLabel = WIDGET_LABEL (SelectionBase,$
                                  UNAME     = 'counts_vs_tof_x_label',$
                                  XOFFSET   = CountsVsTofXLabelSize[0],$
                                  YOFFSET   = CountsVsTofXLabelSize[1],$
                                  SCR_XSIZE = CountsVsTofXLabelSize[2],$
                                  SCR_YSIZE = CountsVsTofXLabelSize[3],$
                                  VALUE     = 'X:')

CountsVsTofYLabel = WIDGET_LABEL (SelectionBase,$
                                  UNAME     = 'counts_vs_tof_y_label',$
                                  XOFFSET   = CountsVsTofYLabelSize[0],$
                                  YOFFSET   = CountsVsTofYLabelSize[1],$
                                  SCR_XSIZE = CountsVsTofYLabelSize[2],$
                                  SCR_YSIZE = CountsVsTofYLabelSize[3],$
                                  VALUE     = 'Y:')

CountsVsTofBankLabel = WIDGET_LABEL (SelectionBase,$
                                     UNAME     = 'counts_vs_tof_bank_label',$
                                     XOFFSET   = CountsVsTofBankLabelSize[0],$
                                     YOFFSET   = CountsVsTofBankLabelSize[1],$
                                     SCR_XSIZE = CountsVsTofBankLabelSize[2],$
                                     SCR_YSIZE = CountsVsTofBankLabelSize[3],$
                                     VALUE     = 'Bank:')

CountsVsTofPixelLabel = WIDGET_LABEL (SelectionBase,$
                                      UNAME     = 'counts_vs_tof_pixel_label',$
                                      XOFFSET   = CountsVsTofPixelLabelSize[0],$
                                      YOFFSET   = CountsVsTofPixelLabelSize[1],$
                                      SCR_XSIZE = CountsVsTofPixelLabelSize[2],$
                                      SCR_YSIZE = CountsVsTofPixelLabelSize[3],$
                                      VALUE     = 'Pixel:')

CountsVsTofFrame = WIDGET_LABEL(SelectionBase,$
                                XOFFSET   = CountsVsTofFrameSize[0],$
                                YOFFSET   = CountsVsTofFrameSize[1],$
                                SCR_XSIZE = CountsVsTofFrameSize[2],$
                                SCR_YSIZE = CountsVsTofFrameSize[3],$
                                FRAME     = 1)

;NeXus/ROI & SELECTION tab
NeXusRoiSelectionTab = WIDGET_TAB(SelectionBase,$
                                  UNAME     = 'nexus_roi_selection_tab',$
                                  LOCATION  = 0,$
                                  XOFFSET   = OpenNeXusSelectionTab[0],$
                                  YOFFSET   = OpenNeXusSelectionTab[1],$
                                  SCR_XSIZE = OpenNeXusSelectionTab[2],$
                                  SCR_YSIZE = OpenNeXusSelectionTab[3],$
                                  SENSITIVE = 1,$
                                  /TRACKING_EVENTS)

;make NeXus/ROI tab (tab#1)
MakeGuiNeXusRoiBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, OpenNeXusTitle

;make Selection tab (tab#2)
MakeGuiSelectionBase, NeXusRoiSelectionTab, OpenNeXusSelectionTab, SelectionTitle

;X, Y and pixelID info box
XYPixelIDBase = WIDGET_BASE(SelectionBase,$
                            XOFFSET   = XYPixelIDBaseSize[0],$
                            YOFFSET   = XYPixelIDBaseSize[1],$
                            SCR_XSIZE = XYPixelIDBaseSize[2],$
                            SCR_YSIZE = XYPixelIDBaseSize[3],$
                            FRAME     = 1)

xbase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = xbaseSize[0],$
                    YOFFSET   = ybaseSize[1],$
                    SCR_XSIZE = xbaseSize[2],$
                    SCR_YSIZE = xbaseSize[3])

Xfield = CW_FIELD(xbase,$
                  UNAME         = 'x_value',$
                  RETURN_EVENTS = 1,$
                  TITLE         = 'X:',$
                  ROW           = 1,$
                  XSIZE         = 2)

ybase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = ybaseSize[0],$
                    YOFFSET   = ybaseSize[1],$
                    SCR_XSIZE = ybaseSize[2],$
                    SCR_YSIZE = ybaseSize[3])

Yfield = CW_FIELD(ybase,$
                  UNAME         = 'y_value',$
                  RETURN_EVENTS = 1,$
                  TITLE         = 'Y:',$
                  ROW           = 1,$
                  XSIZE         = 2)

bankBase = WIDGET_BASE(XYPixelIDBase,$
                       XOFFSET   = bankBaseSize[0],$
                       YOFFSET   = bankBaseSize[1],$
                       SCR_XSIZE = bankBaseSize[2],$
                       SCR_YSIZE = bankBaseSize[3])

bankfield = CW_FIELD(bankBase,$
                     UNAME         = 'bank_value',$
                     RETURN_EVENTS = 1,$
                     TITLE         = 'Bank:',$
                     ROW           = 1,$
                     XSIZE         = 1)

rowBase = WIDGET_BASE(XYPixelIDBase,$
                      XOFFSET   = rowBaseSize[0],$
                      YOFFSET   = rowBaseSize[1],$
                      SCR_XSIZE = rowBaseSize[2],$
                      SCR_YSIZE = rowBaseSize[3])

rowfield = CW_FIELD(rowbase,$
                    UNAME         = 'row_value',$
                    RETURN_EVENTS = 1,$
                    TITLE         = 'Row:',$
                    ROW           = 1,$
                    XSIZE         = 3)

tubeBase = WIDGET_BASE(XYPixelIDBase,$
                       XOFFSET   = tubeBaseSize[0],$
                       YOFFSET   = tubeBaseSize[1],$
                       SCR_XSIZE = tubeBaseSize[2],$
                       SCR_YSIZE = tubeBaseSize[3])

tubefield = CW_FIELD(tubeBase,$
                    UNAME         = 'tube_value',$
                    RETURN_EVENTS = 1,$
                    TITLE         = 'Tube:',$
                    ROW           = 1,$
                    XSIZE         = 3)
                     
pixelIDbase = WIDGET_BASE(XYPixelIDBase,$
                    XOFFSET   = pixelIDbaseSize[0],$
                    YOFFSET   = pixelIDbaseSize[1],$
                    SCR_XSIZE = pixelIDbaseSize[2],$
                    SCR_YSIZE = pixelIDbaseSize[3])

Pixelfield = CW_FIELD(pixelIDbase,$
                      UNAME         = 'pixel_value',$
                      RETURN_EVENTS = 1,$
                      TITLE         = 'PixelID:',$
                      ROW           = 1,$
                      XSIZE         = 5)

countsBase = WIDGET_BASE(XYPixelIDBase,$
                         XOFFSET = countsBaseSize[0],$
                         YOFFSET = countsBaseSize[1],$
                         SCR_XSIZE=countsBaseSize[2],$
                         SCR_YSIZE=countsBaseSize[3])

countsfield = CW_FIELD(countsbase,$
                       UNAME         = 'counts_value',$
                       RETURN_EVENTS = 1,$
                       TITLE         = 'Counts:',$
                       ROW           = 1,$
                       XSIZE         = 8)

;TOP_BANK
TOP_BANK_DRAW = WIDGET_DRAW(SelectionBase,$
                            UNAME     = 'top_bank_draw',$
                            XOFFSET   = TopBankSize[0],$
                            YOFFSET   = TopBankSize[1],$
                            SCR_XSIZE = TopBankSize[2],$
                            SCR_YSIZE = TopBankSize[3],$
                            /BUTTON_EVENTS,$
                            /MOTION_EVENTS)

;BOTTOM_BANK
BOTTOM_BANK_DRAW = WIDGET_DRAW(SelectionBase,$
                               UNAME     = 'bottom_bank_draw',$
                               XOFFSET   = BottomBankSize[0],$
                               YOFFSET   = BottomBankSize[1],$
                               SCR_XSIZE = BottomBankSize[2],$
                               SCR_YSIZE = BottomBankSize[3],$
                               /BUTTON_EVENTS,$
                               /MOTION_EVENTS)

;SELECTION COLOR TOOL
ColorBase = WIDGET_BASE(SelectionBase,$
                        XOFFSET   = ColorBaseSize[0],$
                        YOFFSET   = ColorBaseSize[1],$
                        SCR_XSIZE = ColorBaseSize[2],$
                        SCR_YSIZE = ColorBaseSize[3],$
                        FRAME     = 1)

ColorLabel = WIDGET_LABEL(ColorBase,$
                          XOFFSET = ColorLabelSize[0],$
                          YOFFSET = ColorLabelSize[1],$
                          SCR_XSIZE = ColorLabelSize[2],$
                          SCR_YSIZE = ColorLabelSize[3],$
                          VALUE = 'C O L O R   S E T T I N G S')

SelectionDropList = WIDGET_DROPLIST(ColorBase,$
                                    VALUE     = SelectionDropList,$
                                    XOFFSET   = SelectionDropListSize[0],$
                                    YOFFSET   = SelectionDropListSize[1],$
                                    SCR_XSIZE = SelectionDropListSize[2],$
                                    SCR_YSIZE = SelectionDropListSize[3],$
                                    UNAME     = 'selection_droplist')

ResetColorButton = WIDGET_BUTTON(ColorBase,$
                                 VALUE     = ResetColorButtonTitle,$
                                 XOFFSET   = ResetColorButtonSize[0],$
                                 YOFFSET   = ResetColorButtonSize[1],$
                                 SCR_XSIZE = ResetColorButtonSize[2],$
                                 SCR_YSIZE = ResetColorButtonSize[3],$
                                 UNAME     = 'reset_color_button')

FullResetColorButton = WIDGET_BUTTON(ColorBase,$
                                     VALUE     = FullResetColorButtonTitle,$
                                     XOFFSET   = FullResetColorButtonSize[0],$
                                     YOFFSET   = FullResetColorButtonSize[1],$
                                     SCR_XSIZE = FullResetColorButtonSize[2],$
                                     SCR_YSIZE = FullResetColorButtonSize[3],$
                                     UNAME     = 'full_reset_color_button')

;Color Slider base
ColorSliderBase = WIDGET_BASE(ColorBase,$
                              XOFFSET   = ColorSliderBaseSize[0],$
                              YOFFSET   = ColorSliderBaseSize[1],$
                              SCR_XSIZE = ColorSliderBaseSize[2],$
                              SCR_YSIZE = ColorSliderBaseSize[3],$
                              UNAME     = 'color_slider_base',$
                              FRAME     = 0,$
                              MAP       = 1)

ColorSlider = WIDGET_SLIDER(ColorSliderBase,$
                            UNAME     = 'color_slider',$
                            MAXIMUM   = 250,$
                            MINIMUM   = 0,$
                            XOFFSET   = ColorSliderSize[0],$
                            YOFFSET   = ColorSlidersize[1],$
                            SCR_XSIZE = ColorSliderSize[2],$
                            SCR_YSIZE = ColorSliderSize[3])

ColorSliderLabel = WIDGET_LABEL(ColorSliderBase,$
                                XOFFSET   = ColorSliderLabelSize[0],$
                                YOFFSET   = ColorSliderLabelSize[1],$
                                SCR_XSIZE = ColorSliderLabelSize[2],$
                                SCR_YSIZE = ColorSliderLabelSize[3],$
                                VALUE     = ColorSliderLabelTitle,$
                                /ALIGN_LEFT)

;loadct base
LoadctBase = WIDGET_BASE(ColorBase,$
                         XOFFSET   = ColorSliderBaseSize[0],$
                         YOFFSET   = ColorSliderBaseSize[1],$
                         SCR_XSIZE = ColorSliderBaseSize[2],$
                         SCR_YSIZE = ColorSliderBaseSize[3],$
                         UNAME     = 'Loadct_base',$
                         FRAME     = 0,$
                         MAP       = 0)

LoadctDropList = WIDGET_DROPLIST(LoadctBase,$
                                 UNAME     = 'loadct_droplist',$
                                 Value     = LoadctList,$
                                 XOFFSET   = LoadctDropListSize[0],$
                                 YOFFSET   = LoadctDropListSize[1],$
                                 SCR_XSIZE = LoadctDropListSize[2],$
                                 SCR_YSIZE = LoadctDropListSize[3])
                                 



END
