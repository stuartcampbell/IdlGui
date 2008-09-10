;==============================================================================
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
;==============================================================================

PRO ref_off_spec_shifting_plot2d_event, Event
COMPILE_OPT idl2, hidden

IF (TAG_NAMES(Event, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST') $
  THEN BEGIN
    WIDGET_CONTROL, Event.top, /DESTROY
    RETURN
ENDIF



END



;------------------------------------------------------------------------------
PRO ref_off_spec_shifting_plot2d, Event, GROUP_LEADER=group

WIDGET_CONTROL, Event.top,GET_UVALUE=global

COMPILE_OPT idl2, hidden

; Check if already created.  If so, return.
IF (WIDGET_INFO((*global).w_shifting_plot2d_id, /VALID_ID) NE 0) THEN BEGIN
    WIDGET_CONTROL,(*global).w_shifting_plot2d_id, /SHOW
    RETURN
ENDIF

xsize = 500
ysize = 500

;Built base
title = 'Counts vs Pixels'
wBase = WIDGET_BASE(TITLE = title,$
                    XOFFSET = 500,$
                    YOFFSET = 50,$
                    GROUP_LEADER = group,$
                    /TLB_KILL_REQUEST_EVENTS,$
                    UNAME = 'plot_2d_shifting_base')

wDraw = WIDGET_DRAW(wBase,$
                    SCR_XSIZE = xsize,$
                    SCR_YSIZE = ysize,$
                    UNAME     = 'plot_2d_shifting_draw')

(*global).w_shifting_plot2d_id = wBase
uname = WIDGET_INFO(wDraw,/UNAME)
(*global).w_shifting_plot2d_draw_uname = uname

WIDGET_CONTROL, wBase, /REALIZE
XMANAGER, "ref_off_spec_shifting_plot2d", wBase, /NO_BLOCK
END

;------------------------------------------------------------------------------
PRO plot_selection_OF_2d_plot_mode, Event

WIDGET_CONTROL, Event.top,GET_UVALUE=global

xmin = (*global).plot2d_x_left
ymin = (*global).plot2d_y_left

xmax = Event.x
ymax = Event.y

color = 100 ;color of selection

xaxis = (*(*global).x_axis)
contour_plot_shifting, Event, xaxis
replotAsciiData_shifting, Event
plotReferencedPixels, Event     ;_shifting

plots, xmin, ymin, /DEVICE, COLOR=color
plots, xmax, ymin, /DEVICE, /CONTINUE, COLOR=color, LINESTYLE=1
plots, xmax, ymax, /DEVICE, /CONTINUE, COLOR=color, LINESTYLE=1
plots, xmin, ymax, /DEVICE, /CONTINUE, COLOR=color, LINESTYLE=1
plots, xmin, ymin, /DEVICE, /CONTINUE, COLOR=color, LINESTYLE=1

;plot counts vs pixel of region selected
id_draw = WIDGET_INFO((*global).w_shifting_plot2d_id, $
                      FIND_BY_UNAME=(*global).w_shifting_plot2d_draw_uname)
WIDGET_CONTROL, id_draw, GET_VALUE=id_value
WSET,id_value

total_array = (*(*global).total_array)

xmin = MIN([xmin,xmax],MAX=xmax)
ymin = MIN([ymin,ymax],MAX=ymax)

IF (xmin NE xmax AND $
    ymin NE ymax) THEN BEGIN
    data_to_plot = total_array(xmin:xmax,ymin:ymax)
    t_data_to_plot = total(data_to_plot,1)
    sz = N_ELEMENTS(t_data_to_plot)
    new_array = CONGRID(t_data_to_plot,sz/2)
    help, new_array
    xrange = INDGEN(sz) + ymin/2
    xtitle = 'Pixel #'
    ytitle = 'Counts'
    plot, xrange, new_array, $
      XRANGE=[ymin/2,ymax/2], $
      XTITLE=xtitle, $
      YTITLE=ytitle
ENDIF



END
