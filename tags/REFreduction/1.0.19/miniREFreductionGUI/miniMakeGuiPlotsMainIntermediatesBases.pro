PRO miniMakeGuiPlotsMainIntermediatesBases, PLOTS_BASE, PlotsTitle

;define widgets variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
PlotsDropListSize         = [0,0]

PlotsErrorMessageBaseSize = [300, $
                             2, $
                             481, $
                             30]

PlotsErrorMessageSize     = [0, $
                             0, $
                             481, $
                             30]

MainPlotBaseSize          = [150, $
                             5, $
                             600, $
                             800]

MainPlotDrawSize          = [50, $
                             35, $
                             500, $
                             450]

PlotTextFieldSize         = [0, $
                             MainPlotDrawSize[1]+MainPlotDrawSize[3]+5,$
                             MainPlotBaseSize[2], $
                             150]

;###############################################################################
;############################### Create GUI ####################################
;###############################################################################

;droplist
PlotsDropList = widget_droplist(PLOTS_BASE,$
                                UNAME     = 'plots_droplist',$
                                XOFFSET   = PlotsDropListSize[0],$
                                YOFFSET   = PlotsDropListSize[1],$
                                VALUE     = PlotsTitle,$
                                SENSITIVE = 0)


;error message base/label
PLOTS_ERROR_BASE = WIDGET_BASE(PLOTS_BASE,$
                               XOFFSET   = PlotsErrorMessageBaseSize[0],$
                               YOFFSET   = PlotsErrorMessageBaseSize[1],$
                               SCR_XSIZE = PlotsErrorMessageBaseSize[2],$
                               SCR_YSIZE = PlotsErrorMessageBaseSize[3],$
                               UNAME     = 'plots_error_base',$
                               MAP       = 0,$
                               FRAME     = 1)

PlotsErrorMessage = WIDGET_LABEL(PLOTS_ERROR_BASE,$
                                 XOFFSET   = PlotsErrorMessageSize[0],$
                                 YOFFSET   = PlotsErrorMessageSize[1],$
                                 SCR_XSIZE = PlotsErrorMessageSize[2],$
                                 SCR_YSIZE = PlotsErrorMessageSize[3],$
                                 VALUE     = 'ERROR: not enough data to plot',$
                                 FRAME     = 1,$
                                 UNAME     = 'plots_error_message')

MainPlotBase = Widget_base(PLOTS_BASE,$
                           UNAME     = 'main_plot_base',$
                           XOFFSET   = MainPlotBaseSize[0],$
                           YOFFSET   = MainPlotBaseSize[1],$
                           SCR_XSIZE = MainPlotBaseSize[2],$
                           SCR_YSIZE = MainPlotBaseSize[3])
                          
                          ;drawing region
MainPlotDraw = widget_draw(MainPlotBase,$
                           UNAME     = 'main_plot_draw',$
                           XOFFSET   = MainPlotDrawSize[0],$
                           YOFFSET   = MainPlotDrawSize[1],$
                           SCR_XSIZE = MainPlotDrawSize[2],$
                           SCR_YSIZE = MainPlotDrawSize[3])

;text field
PlotTextField = widget_text(MainPlotBase,$
                            XOFFSET   = PlotTextFieldSize[0],$
                            YOFFSET   = PlotTextFieldSize[1],$
                            SCR_XSIZE = PlotTextFieldSize[2],$
                            SCR_YSIZE = PlotTextFieldSize[3],$
                            UNAME     ='plots_text_field',$
                            /SCROLL,$
                            /WRAP)

                                                            
END
