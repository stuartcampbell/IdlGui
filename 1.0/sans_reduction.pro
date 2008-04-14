;===============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;===============================================================================

PRO BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;get the current folder
CD, CURRENT = current_folder

APPLICATION = 'SANSreduction'
VERSION     = '1.0.0'
DEBUGGING   = 'yes'

;define initial global values - these could be input via external
;file or other means

;get ucams of user if running on linux
;and set ucams to 'j35' if running on darwin

IF (!VERSION.os EQ 'darwin') THEN BEGIN
   ucams = 'j35'
ENDIF ELSE BEGIN
   ucams = get_ucams()
ENDELSE

;define global variables
global = PTR_NEW ({ version         : VERSION,$
                    processing      : '(PROCESSING)',$
                    ok              : 'OK',$
                    failed          : 'FAILED',$
                    nexus_extension : 'nxs',$
                    nexus_filter    : '*.nxs',$
                    nexus_title     : 'Browse NeXus File',$
                    nexus_path      : '/SNS/'})

;debugging version of program
IF (DEBUGGING EQ 'yes' AND $
    ucams EQ 'j35') THEN BEGIN
    nexus_path           = '~/SVN/IdlGui/branches/SANSreduction/1.0'
    (*global).nexus_path = nexus_path
ENDIF

MainBaseTitle  = 'SANS Data Reduction GUI'
MainBaseSize   = [30,25,695,550]
MainBaseTitle += ' - ' + VERSION

;===============================================================================
;Build Main Base ===============================================================
MAIN_BASE = WIDGET_BASE( GROUP_LEADER = wGroup,$
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
widget_control, MAIN_BASE, SET_UVALUE=global

;Build Tab1
make_gui_main_tab, MAIN_BASE, MainBaseSize

Widget_Control, /REALIZE, MAIN_BASE
XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK

;===============================================================================
;===============================================================================

;logger message
logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
error = 0
CATCH, error
IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
ENDIF ELSE BEGIN
    spawn, logger_message
ENDELSE

;Debugging only ----------------------------------------------------------------
IF (DEBUGGING EQ 'yes' AND $
    ucams EQ 'j35') THEN BEGIN
;show tab #2
    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 0
ENDIF

END

;===============================================================================
; Empty stub procedure used for autoloading.
PRO sans_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end





