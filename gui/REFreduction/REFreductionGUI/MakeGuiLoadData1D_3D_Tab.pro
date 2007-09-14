PRO MakeGuiLoadData1D_3D_Tab, D_DD_Tab, $
                              D_DD_TabSize, $
                              D_DD_TabTitle, $
                              GlobalLoadGraphs, $
                              LoadctList

;define dimension and position of various componentsxs
RescaleBaseSize = [ 0, $
                    GlobalLoadGraphs[3]+0, $
                    GlobalLoadGraphs[2], $
                    D_DD_TabSize[3]-GlobalLoadGraphs[3]]

;1d_3d_loadct button
LoadctDroplistSize  = [160,680,100,30]
LoadctDropListTitle = 'Contrast Type'

;label
y_vertical_offset = 40
XaxisLabelSize  = [5,15]
YaxisLabelSize  = [XaxisLabelSize[0],XaxisLabelSize[1]+y_vertical_offset]
ZaxisLabelSize  = [YaxisLabelSize[0],YaxisLabelSize[1]+y_vertical_offset]

XaxisLabeltitle = 'X-axis:'
YaxisLabeltitle = 'Y-axis:'
ZaxisLabelTitle = 'Z-axis:'

;droplist
AxisScaleList  = ['linear','log']
x1_offset = 37
y_offset= 10
XaxisScaleSize = [XaxisLabelSize[0] + x1_offset,$
                  XaxisLabelSize[1] - y_offset]
YaxisScaleSize = [YaxisLabelSize[0] + x1_offset,$
                  YaxisLabelSize[1] - y_offset]
ZaxisScaleSize = [ZaxisLabelSize[0] + x1_offset,$
                  ZaxisLabelSize[1] - y_offset]

;min/max
x2_offset= 85
ZaxisMinBaseSize    = [ZaxisScaleSize[0]+x2_offset,$
                       ZaxisScaleSize[1],$
                       80,35]
x3_offset = 80
ZaxisMaxBaseSize    = [ZaxisMinBaseSize[0]+x3_offset,$
                       ZaxisMinBaseSize[1],$
                       80,35]
ZaxisMinBaseTitle   = 'Min'
ZaxisMaxBaseTitle   = 'Max'

XaxisResetButtonSize  = [290,XaxisScaleSize[1]+2,70,30]
XaxisResetButtonTitle = 'RESET X'
YaxisResetButtonSize  = [XaxisResetButtonSize[0],$
                         YaxisScaleSize[1]+2,$
                         XaxisResetButtonSize[2:3]]
YaxisResetButtonTitle = 'RESET Y'
ZaxisResetButtonSize  = [XaxisResetButtonSize[0],$
                         ZaxisScaleSize[1]+2,$
                         XaxisResetButtonSize[2:3]]
ZaxisResetButtonTitle = 'RESET Z'

;XYaxis
XYAxisLabelSize      = [ZaxisLabelSize[0],ZaxisLabelSize[1]+y_vertical_offset]
XYAxisLabelTitle     = 'XY-axis:'
x4_offset= 50
XYAxisAngleBaseSize  = [XYAxisLabelSize[0]+x4_offset,$
                       XYAxisLabelSize[1]-10,$
                       85,35]
XYAxisAngleBaseTitle = 'Angle:'
x5_offset = 83
XYAxisAngleResetButtonSize  = [XYAxisAngleBaseSize[0]+x5_offset,$
                               XYAxisAngleBaseSize[1]+3,$
                               40,30]
XYAxisAngleResetButtonTitle = 'RST'

x6_offset = 180
ZZAxisLabelSize      = [XYAxisLabelSize[0]+x6_offset, $
                        XYAxisLabelSize[1]]
ZZAxisLabelTitle     = 'Z-axis:'
ZZAxisAngleBaseSize  = [ZZAxisLabelSize[0]+x4_offset,$
                        XYAxisAngleBaseSize[1],$
                        XYAxisAngleBaseSize[2:3]]
ZZAxisAngleBaseTitle = 'Angle:'
ZZAxisAngleResetButtonSize  = [ZZAxisAngleBaseSize[0]+x5_offset,$
                               XYAxisAngleResetButtonSize[1],$
                               XYAxisAngleResetButtonSize[2:3]]
ZZAxisAngleResetButtonTitle = 'RST'

;'Google' rotation base
Google_xoff=365
GoogleRotationBaseSize      = [Google_xoff,12,240,130]
GoogleRotationBaseTitleSize = [Google_xoff+70,2]
GoogleRotationBaseTitle     = 'Rotation Interface'

;google xy-axis MM/M/P/PP
GoogleXYaxisMMButtonSize  = [8,50,50,25]
GoogleXYaxisMMButtonTitle = '--'
x1 = 50
GoogleXYAxisMButtonSize   = [GoogleXYaxisMMButtonSize[0]+x1,$
                             GoogleXYaxisMMButtonSize[1]+3,$
                             GoogleXYaxisMMButtonSize[2]-15,$
                             GoogleXYaxisMMButtonSize[3]-6]
GoogleXYaxisMButtonTitle  = '-'
x2 = 95
GoogleXYaxisPButtonSize   = [GoogleXYaxisMButtonSize[0]+x2,$
                            GoogleXYaxisMButtonSize[1:3]]
GoogleXYaxisPButtonTitle  = '+'
x3 = 35
GoogleXYaxisPPButtonSize  = [GoogleXYaxisPButtonSize[0]+x3,$
                            GoogleXYaxisMMButtonSize[1:3]]
GoogleXYaxisPPButtonTitle = '++'

;reset button
x4=85
GoogleResetButtonSize    = [GoogleXYaxisMMButtonSize[0]+x4,$
                            GoogleXYaxisMMButtonSize[1]+5,$
                            58,17]
GoogleResetButtonTitle   = 'RESET'

;google z-axis PP/P/M/MM
GoogleZaxisPPButtonSize  = [102,5,40,30]
GoogleZaxisPPButtonTitle  = '++'
y1 = 30
GoogleZaxisPButtonSize   = [GoogleZaxisPPButtonSize[0]-4,$
                            GoogleZaxisPPButtonSize[1]+y1,$
                            GoogleZaxisPPButtonSize[2]+8,$
                            18]
GoogleZaxisPButtonTitle  = '+'
y2 = 38
GoogleZaxisMButtonSize   = [GoogleZaxisPButtonSize[0],$
                            GoogleZaxisPButtonSize[1]+y2,$
                            GoogleZaxisPButtonSize[2],$
                            GoogleZaxisPButtonSize[3]]
GoogleZaxisMButtonTitle  = '-'
y3 = 21
GoogleZaxisMMButtonSize  = [GoogleZaxisPPButtonSize[0],$
                            GoogleZaxisMButtonSize[1]+y3,$
                            GoogleZaxisPPButtonSize[2],$
                            GoogleZaxisPPButtonSize[3]]
GoogleZaxisMMButtonTitle = '--'

;***********************************************************************************
;Build 1D_3D tab
;***********************************************************************************
load_data_D_3D_tab_base = widget_base(D_DD_Tab,$
                                      uname='load_data_d_3d_tab_base',$
                                      title=D_DD_TabTitle[2],$
                                      xoffset=D_DD_TabSize[0],$
                                      yoffset=D_DD_TabSize[1],$
                                      scr_xsize=D_DD_TabSize[2],$
                                      scr_ysize=D_DD_TabSize[3])

LoadctDroplist = WIDGET_DROPLIST(load_data_D_3D_tab_base,$
                                 VALUE     = LoadctList,$
                                 UNAME     = 'data_loadct_1d_3d_droplist',$
                                 XOFFSET   = LoadctDroplistSize[0],$
                                 YOFFSET   = LoadctDroplistSize[1],$
                                 SENSITIVE = 1,$
                                 /TRACKING_EVENTS)

load_data_D_3D_draw = widget_draw(load_data_D_3D_tab_base,$
                                  xoffset=GlobalLoadGraphs[0],$
                                  yoffset=GlobalLoadGraphs[1],$
                                  scr_xsize=GlobalLoadGraphs[2],$
                                  scr_ysize=GlobalLoadGraphs[3],$
                                  uname='load_data_d_3d_draw',$
                                  retain=2,$
                                  /button_events,$
                                  /motion_events)

;SCALE BASE
RescaleBase = widget_base(load_data_D_3D_tab_base,$
                          xoffset=RescaleBaseSize[0],$
                          yoffset=RescaleBaseSize[1],$
                          scr_xsize=RescaleBaseSize[2],$
                          scr_ysize=RescaleBaseSize[3],$
                          frame=0)

;X-AXIS
XaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET  = XaxisLabelSize[0],$
                          YOFFSET  = XaxisLabelSize[1],$
                          VALUE    = XaxisLabelTitle)

XaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = XaxisScaleSize[0],$
                             YOFFSET = XaxisScaleSize[1],$
                             UNAME   = 'data1d_x_axis_scale')

;Y-AXIS
YaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET  = YaxisLabelSize[0],$
                          YOFFSET  = YaxisLabelSize[1],$
                          VALUE    = YaxisLabelTitle)

YaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = YaxisScaleSize[0],$
                             YOFFSET = YaxisScaleSize[1],$
                             UNAME   = 'data1d_y_axis_scale')

;Z-AXIS
ZaxisLabel = WIDGET_LABEL(RescaleBase,$
                          XOFFSET  = ZaxisLabelSize[0],$
                          YOFFSET  = ZaxisLabelSize[1],$
                          VALUE    = ZaxisLabelTitle)

ZaxisMinBase = WIDGET_BASE(RescaleBase,$
                           XOFFSET   = ZaxisMinBaseSize[0],$
                           YOFFSET   = ZaxisMinBaseSize[1],$
                           SCR_XSIZE = ZaxisMinBaseSize[2],$
                           SCR_YSIZE = ZaxisMinBaseSize[3],$
                           UNAME     = 'data_z_axis_min_base')

ZaxisMinCwfield = CW_FIELD(ZaxisMinBase,$
                           ROW           = 1,$
                           XSIZE         = 5,$
                           YSIZE         = 1,$
                           /FLOAT,$
                           RETURN_EVENTS = 1,$
                           TITLE         = ZaxisMinBaseTitle,$
                           UNAME         = 'data1d_z_axis_min_cwfield')

ZaxisMaxBase = WIDGET_BASE(RescaleBase,$
                           XOFFSET   = ZaxisMaxBaseSize[0],$
                           YOFFSET   = ZaxisMaxBaseSize[1],$
                           SCR_XSIZE = ZaxisMaxBaseSize[2],$
                           SCR_YSIZE = ZaxisMaxBaseSize[3],$
                           UNAME     = 'data1d_z_axis_max_base')

ZaxisMaxCwfield = CW_FIELD(ZaxisMaxBase,$
                           ROW           = 1,$
                           XSIZE         = 5,$
                           YSIZE         = 1,$
                           /FLOAT,$
                           RETURN_EVENTS = 1,$
                           TITLE         = ZaxisMaxBaseTitle,$
                           UNAME         = 'data1d_z_axis_max_cwfield')

ZaxisScale = WIDGET_DROPLIST(RescaleBase,$
                             VALUE   = AxisScaleList,$
                             XOFFSET = ZaxisScaleSize[0],$
                             YOFFSET = ZaxisScaleSize[1],$
                             UNAME   = 'data1d_z_axis_scale')


ZaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = ZaxisResetButtonSize[0],$
                                 YOFFSET   = ZaxisResetButtonSize[1],$
                                 SCR_XSIZE = ZaxisResetButtonSize[2],$
                                 SCR_YSIZE = ZaxisResetButtonSize[3],$
                                 VALUE     = ZaxisResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'data1d_z_axis_reset_button')

;XY and Z axis angle interaction
XYaxisLabel = WIDGET_LABEL(RescaleBase,$
                           XOFFSET  = XYaxisLabelSize[0],$
                           YOFFSET  = XYaxisLabelSize[1],$
                           VALUE    = XYaxisLabelTitle)

XYaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = XYaxisAngleResetButtonSize[0],$
                                 YOFFSET   = XYaxisAngleResetButtonSize[1],$
                                 SCR_XSIZE = XYaxisAngleResetButtonSize[2],$
                                 SCR_YSIZE = XYaxisAngleResetButtonSize[3],$
                                 VALUE     = XYaxisAngleResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'data1d_xy_axis_reset_button')

XYaxisAngleBase = WIDGET_BASE(RescaleBase,$
                              XOFFSET   = XYaxisAngleBaseSize[0],$
                              YOFFSET   = XYaxisAngleBaseSize[1],$
                              SCR_XSIZE = XYaxisAngleBaseSize[2],$
                              SCR_YSIZE = XYaxisAngleBaseSize[3],$
                              UNAME     = 'data_xy_axis_angle_base')

XYaxisAngleCwfield = CW_FIELD(XYaxisAngleBase,$
                              ROW           = 1,$
                              XSIZE         = 3,$
                              YSIZE         = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = XYaxisAngleBaseTitle,$
                              UNAME         = 'data1d_xy_axis_angle_cwfield')

ZZaxisLabel = WIDGET_LABEL(RescaleBase,$
                           XOFFSET  = ZZaxisLabelSize[0],$
                           YOFFSET  = ZZaxisLabelSize[1],$
                           VALUE    = ZZaxisLabelTitle)

ZZaxisResetButton = WIDGET_BUTTON(RescaleBase,$
                                 XOFFSET   = ZZaxisAngleResetButtonSize[0],$
                                 YOFFSET   = ZZaxisAngleResetButtonSize[1],$
                                 SCR_XSIZE = ZZaxisAngleResetButtonSize[2],$
                                 SCR_YSIZE = ZZaxisAngleResetButtonSize[3],$
                                 VALUE     = ZZaxisAngleResetButtonTitle,$
                                 SENSITIVE = 1,$
                                 UNAME     = 'data1d_zz_axis_reset_button')

ZZaxisAngleBase = WIDGET_BASE(RescaleBase,$
                              XOFFSET   = ZZaxisAngleBaseSize[0],$
                              YOFFSET   = ZZaxisAngleBaseSize[1],$
                              SCR_XSIZE = ZZaxisAngleBaseSize[2],$
                              SCR_YSIZE = ZZaxisAngleBaseSize[3],$
                              UNAME     = 'data_zz_axis_angle_base')

ZZaxisAngleCwfield = CW_FIELD(ZZaxisAngleBase,$
                              ROW           = 1,$
                              XSIZE         = 3,$
                              YSIZE         = 1,$
                              /FLOAT,$
                              RETURN_EVENTS = 1,$
                              TITLE         = ZZaxisAngleBaseTitle,$
                              UNAME         = 'data1d_zz_axis_angle_cwfield')

;GOOGLE INTERACTIVE BASE
GoogleRotationTitle = WIDGET_LABEL(RescaleBase,$
                                   XOFFSET = GoogleRotationBaseTitleSize[0],$
                                   YOFFSET = GoogleRotationBaseTitleSize[1],$
                                   VALUE   = GoogleRotationBaseTitle)

GoogleRotationBase = WIDGET_BASE(RescaleBase,$
                                 XOFFSET   = GoogleRotationBaseSize[0],$
                                 YOFFSET   = GoogleRotationBaseSize[1],$
                                 SCR_XSIZE = GoogleRotationBaseSize[2],$
                                 SCR_YSIZE = GoogleRotationBaseSize[3],$
                                 UNAME     = 'data_google_rotation_base',$
                                 FRAME     = 1)

;GOOGLE XY-AXIS
GoogleXYaxisMMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleXYaxisMMButtonSize[0],$
                                    YOFFSET   = GoogleXYaxisMMButtonSize[1],$
                                    SCR_XSIZE = GoogleXYaxisMMButtonSize[2],$
                                    SCR_YSIZE = GoogleXYaxisMMButtonSize[3],$
                                    VALUE     = GoogleXYaxisMMButtonTitle,$
                                    UNAME     = 'data1d_google_xy_axis_mm_button',$
                                    SENSITIVE = 1)

GoogleXYaxisMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleXYaxisMButtonSize[0],$
                                   YOFFSET   = GoogleXYaxisMButtonSize[1],$
                                   SCR_XSIZE = GoogleXYaxisMButtonSize[2],$
                                   SCR_YSIZE = GoogleXYaxisMButtonSize[3],$
                                   VALUE     = GoogleXYaxisMButtonTitle,$
                                   UNAME     = 'data1d_google_xy_axis_m_button',$
                                   SENSITIVE = 1)

GoogleXYaxisPPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleXYaxisPPButtonSize[0],$
                                    YOFFSET   = GoogleXYaxisPPButtonSize[1],$
                                    SCR_XSIZE = GoogleXYaxisPPButtonSize[2],$
                                    SCR_YSIZE = GoogleXYaxisPPButtonSize[3],$
                                    VALUE     = GoogleXYaxisPPButtonTitle,$
                                    UNAME     = 'data1d_google_xy_axis_pp_button',$
                                    SENSITIVE = 1)

GoogleXYaxisPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleXYaxisPButtonSize[0],$
                                   YOFFSET   = GoogleXYaxisPButtonSize[1],$
                                   SCR_XSIZE = GoogleXYaxisPButtonSize[2],$
                                   SCR_YSIZE = GoogleXYaxisPButtonSize[3],$
                                   VALUE     = GoogleXYaxisPButtonTitle,$
                                   UNAME     = 'data1d_google_xy_axis_p_button',$
                                   SENSITIVE = 1)
;RESET
GoogleResetButton = WIDGET_BUTTON(GoogleRotationBase,$
                                  XOFFSET   = GoogleResetButtonSize[0],$
                                  YOFFSET   = GoogleResetButtonSize[1],$
                                  SCR_XSIZE = GoogleResetButtonSize[2],$
                                  SCR_YSIZE = GoogleResetButtonSize[3],$
                                  UNAME     = 'data1d_google_reset_button',$
                                  VALUE     = GoogleResetButtonTitle,$
                                  SENSITIVE = 1)


;GOOGLE Z-AXIS
GoogleZaxisPPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleZaxisPPButtonSize[0],$
                                    YOFFSET   = GoogleZaxisPPButtonSize[1],$
                                    SCR_XSIZE = GoogleZaxisPPButtonSize[2],$
                                    SCR_YSIZE = GoogleZaxisPPButtonSize[3],$
                                    VALUE     = GoogleZaxisPPButtonTitle,$
                                    UNAME     = 'data1d_google_z_axis_pp_button',$
                                    SENSITIVE = 1)

GoogleZaxisPButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleZaxisPButtonSize[0],$
                                   YOFFSET   = GoogleZaxisPButtonSize[1],$
                                   SCR_XSIZE = GoogleZaxisPButtonSize[2],$
                                   SCR_YSIZE = GoogleZaxisPButtonSize[3],$
                                   VALUE     = GoogleZaxisPButtonTitle,$
                                   UNAME     = 'data1d_google_z_axis_p_button',$
                                   SENSITIVE = 1)

GoogleZaxisMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                    XOFFSET   = GoogleZaxisMButtonSize[0],$
                                    YOFFSET   = GoogleZaxisMButtonSize[1],$
                                    SCR_XSIZE = GoogleZaxisMButtonSize[2],$
                                    SCR_YSIZE = GoogleZaxisMButtonSize[3],$
                                    VALUE     = GoogleZaxisMButtonTitle,$
                                    UNAME     = 'data1d_google_z_axis_m_button',$
                                    SENSITIVE = 1)

GoogleZaxisMMButton = WIDGET_BUTTON(GoogleRotationBase,$
                                   XOFFSET   = GoogleZaxisMMButtonSize[0],$
                                   YOFFSET   = GoogleZaxisMMButtonSize[1],$
                                   SCR_XSIZE = GoogleZaxisMMButtonSize[2],$
                                   SCR_YSIZE = GoogleZaxisMMButtonSize[3],$
                                   VALUE     = GoogleZaxisMMButtonTitle,$
                                   UNAME     = 'data1d_google_z_axis_mm_button',$
                                   SENSITIVE = 1)

END

