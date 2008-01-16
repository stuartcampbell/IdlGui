PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
cd, current=current_folder

VERSION = '(1.0.0)'

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin
if (!VERSION.os EQ 'darwin') then begin
   ucams = 'j35'
endif else begin
   ucams = get_ucams()
endelse

;get hostname
spawn, 'hostname', hostname

;define global variables
global = ptr_new ({ ucams                 : ucams,$
                    debugger              : 'j35'})


IF (ucams EQ (*global).debugger) THEN BEGIN
    MainBaseSize  = [30,25,700,700]
ENDIF ELSE BEGIN
    MainBaseSize  = [30,25,700,530]
ENDELSE
MainBaseTitle = 'Plot ARCS'
MainBaseTitle += ' - ' + VERSION

;Build Main Base
MAIN_BASE = Widget_Base( GROUP_LEADER = wGroup,$
                         UNAME        = 'MAIN_BASE',$
                         SCR_XSIZE    = MainBaseSize[2],$
                         SCR_YSIZE    = MainBaseSize[3],$
                         XOFFSET      = MainBaseSize[0],$
                         YOFFSET      = MainBaseSize[1],$
                         TITLE        = MainBaseTitle,$
                         SPACE        = 0,$
                         XPAD         = 0,$
                         YPAD         = 2)

;attach global structure with widget ID of widget main base widget ID
widget_control, MAIN_BASE, set_uvalue=global

;Create main base
MakeGuiInputBase, MAIN_BASE, MainBaseSize

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
;XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK, CLEANUP='gg_Cleanup' 

END


; Empty stub procedure used for autoloading.
pro plot_arcs, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





