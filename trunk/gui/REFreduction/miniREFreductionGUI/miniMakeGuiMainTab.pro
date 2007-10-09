PRO miniMakeGuiMainTab, MAIN_BASE, MainBaseSize, instrument, PlotsTitle

;define widget variables
;[xoffset, yoffset, scr_xsize, scr_ysize]
MainTabSize = [0,0,MainBaseSize[2],MainBaseSize[3]]

;Tab titles
LoadTabTitle     = '       LOAD       ' 
ReduceTabTitle   = '      REDUCE      ' 
PlotsTabTitle    = '       PLOTS      ' 
LogBookTabTitle  = '     LOG BOOK     ' 
SettingsTabTitle = '     SETTINGS     ' 

;build widgets
MAIN_TAB = WIDGET_TAB(MAIN_BASE,$
                      UNAME='main_tab',$
                      LOCATION=0,$
                      XOFFSET=MainTabSize[0],$
                      YOFFSET=MainTabSize[1],$
                      SCR_XSIZE=MainTabSize[2],$
                      SCR_YSIZE=MainTabSize[3],$
                      /TRACKING_EVENTS,$
                      sensitive=1)

;first tab selected
;widget_control, Main_Tab, set_tab_current = 0 ;LOAD

;build LOAD tab
miniMakeGuiLoadTab, MAIN_TAB, MainTabSize, LoadTabTitle, instrument

;build REDUCE tab
miniMakeGuiReduceTab, MAIN_TAB, MainTabSize, ReduceTabTitle, PlotsTitle

;build PLOTS tab
miniMakeGuiPlotsTab, MAIN_TAB, MainTabSize, PlotsTabTitle, PlotsTitle

;build LOG_BOOK tab
miniMakeGuiLogBookTab, MAIN_TAB, MainTabSize, LogBookTabTitle

;;build SETTINGS tab
;MakeGuiSettingsTab, MAIN_TAB, MainTabSize, SettingsTabTitle


END
