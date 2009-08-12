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

PRO plot_transmission_step3_scale, Event

  ;change color of background
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step3_draw_scale')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  device, decomposed=1
  sys_color_window_bk = (*global).sys_color_window_bk
  
  xmargin_left   = 8.2
  xmargin_right  = 5.5
  ymargin_bottom = 4.9
  ymargin_top    = 3.1
  plot, randomn(s,80), $
    XRANGE     = [84,108],$
    YRANGE     = [116,142],$
    COLOR      = convert_rgb([0B,0B,255B]), $
    ;    BACKGROUND = convert_rgb(sys_color.face_3d),$
    BACKGROUND = convert_rgb(sys_color_window_bk),$
    THICK      = 1, $
    TICKLEN    = -0.025, $
    XTICKLAYOUT = 0,$
    XSTYLE      = 1,$
    YSTYLE      = 1,$
    YTICKLAYOUT = 0,$
    XTICKS      = 12,$
    YTICKS      = 13,$
    XTITLE      = 'TUBES',$
    YTITLE      = 'PIXELS',$
    XMARGIN     = [xmargin_left, xmargin_right],$
    YMARGIN     = [ymargin_bottom, ymargin_top],$
    /NODATA
  AXIS, yaxis=1, YRANGE=[116,142], YTICKS=13, YSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
  AXIS, xaxis=1, XRANGE=[84,108], XTICKS=12, XSTYLE=1, $
    COLOR=convert_rgb([0B,0B,255B]), TICKLEN = -0.025
    
  DEVICE, decomposed = 0
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step3_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  both_banks = (*global).both_banks
  zoom_data = both_banks[*,116:141,84:107]
  
  (*(*global).step3_3d_data) = zoom_data
  
  t_zoom_data = TOTAL(zoom_data,1)
  tt_zoom_data = TRANSPOSE(t_zoom_data)
  (*(*global).step3_tt_zoom_data) = tt_zoom_data
  rtt_zoom_data = CONGRID(tt_zoom_data, 400, 300)
  (*(*global).step3_rtt_zoom_data) = rtt_zoom_data
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step3_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  TVSCL, rtt_zoom_data
  
END

;------------------------------------------------------------------------------
PRO replot_transmission_step3_main_plot, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  data = (*(*global).step3_rtt_zoom_data)
  
  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='manual_transmission_step3_draw')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  
  IF (~isTranManualStep3LinSelected(Event)) THEN BEGIN ;log mode
    index = WHERE(data EQ 0, nbr)
    IF (nbr GT 0) THEN BEGIN
      data[index] = !VALUES.D_NAN
    ENDIF
    Data_log = ALOG10(Data)
    Data_log_bytscl = BYTSCL(Data_log,/NAN)
    data = data_log_bytscl
  ENDIF
  
  TVSCL, data
  
END

;------------------------------------------------------------------------------
PRO plot_transmission_step3_bottom_plots, Event

  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  counts_vs_xy = (*(*global).step3_tt_zoom_data)
  counts_vs_x = TOTAL(counts_vs_xy,2)
  counts_vs_y = TOTAL(counts_vs_xy,1)
  (*(*global).step3_counts_vs_x) = counts_vs_x
  (*(*global).step3_counts_vs_y) = counts_vs_y
  
  ;plot data
  ;Counts vs tube (integrated over y)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_x)) + (*global).step3_xoffset_plot
;  (*(*global).tube_x_axis) = x_axis
  id = WIDGET_INFO(Event.top,$
  FIND_BY_UNAME='trans_manual_step3_counts_vs_tube_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_x, XSTYLE=1, XTITLE='Tube #', YTITLE='Counts', $
    TITLE = 'Counts vs tube integrated over pixel', $
    XTICKS = 12, $
    PSYM = -1
    
  ;Counts vs tube (integrated over x)
  x_axis = INDGEN(N_ELEMENTS(counts_vs_y)) + (*global).step3_yoffset_plot
;  (*(*global).pixel_x_axis) = x_axis
  id = WIDGET_INFO(Event.top,$
  FIND_BY_UNAME='trans_manual_step3_counts_vs_pixel_plot')
  WIDGET_CONTROL, id, GET_VALUE=id_value
  WSET, id_value
  plot, x_axis, counts_vs_y, XSTYLE=1, XTITLE='Pixel #', YTITLE='Counts', $
    TITLE = 'Counts vs pixel integrated over tube', $
    XTICKS = 13, $
    PSYM = -1
    
END

