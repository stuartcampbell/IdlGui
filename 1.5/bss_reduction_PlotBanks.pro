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

PRO PlotBank1Grid, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;top bank
  view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  x_coeff = (*global).Xfactor
  y_coeff = (*global).Yfactor
  colorY  = (*global).ColorVerticalGrid
  colorX  = (*global).ColorHorizontalGrid
  
  for i=1,56 do begin
    plots, i*x_coeff, 0, /device, color=colorY
    plots, i*x_coeff, 64*y_coeff, /device, /continue, color=colorY
  endfor
  
  for i=1,64 do begin
    plots, 0,i*y_coeff, /device,color=colorX
    plots, 64*x_coeff, i*y_coeff, /device, /continue, color=colorX
  endfor
  
END




PRO PlotBank2Grid, Event

  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  ;top bank
  view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  x_coeff = (*global).Xfactor
  y_coeff = (*global).Yfactor
  colorY  = (*global).ColorVerticalGrid
  colorX  = (*global).ColorHorizontalGrid
  
  for i=1,56 do begin
    plots, i*x_coeff, 0, /device, color=colorY
    plots, i*x_coeff, 64*y_coeff, /device, /continue, color=colorY
  endfor
  
  for i=1,64 do begin
    plots, 0,i*y_coeff, /device,color=colorX
    plots, 64*x_coeff, i*y_coeff, /device, /continue, color=colorX
  endfor
  
END

;------------------------------------------------------------------------------
;This function will plot the bank1 and bank2 grids
PRO PlotBanksGrid, Event
  PlotBank1Grid, Event
  PlotBank2Grid, Event
END

;------------------------------------------------------------------------------
PRO bss_reduction_PlotBank1, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  bank1_sum = (*(*global).bank1_sum)
  
  ;transpose data
  bank1_sum_transpose = transpose(bank1_sum)
  
  ;rebin data
  Nx = (*global).Nx+1
  Ny = (*global).Ny
  
  Xfactor = (*global).Xfactor
  Yfactor = (*global).Yfactor
  
  tvimg_bank1 = rebin(bank1_sum_transpose,Nx*Xfactor, Ny*Yfactor,/sample)
  
  ;plot data
  ;top bank = bank1
  view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  tvscl, tvimg_bank1, /NAN
END

;------------------------------------------------------------------------------
PRO bss_reduction_PlotBank2, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  bank2_sum = (*(*global).bank2_sum)
  
  ;transpose data
  bank2_sum_transpose = transpose(bank2_sum)
  
  ;rebin data
  Nx = (*global).Nx+1
  Ny = (*global).Ny
  
  Xfactor = (*global).Xfactor
  Yfactor = (*global).Yfactor
  
  tvimg_bank2 = rebin(bank2_sum_transpose,Nx*Xfactor, Ny*Yfactor,/sample)
  
  ;bottom bank = bank2
  view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  tvscl, tvimg_bank2,/NAN
END


;------------------------------------------------------------------------------
PRO bss_reduction_PlotBank3, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  bank3_sum = (*(*global).bank3_sum)
  
  ;transpose data
  bank3_sum_transpose = transpose(bank3_sum)
  
  ;rebin data
  Nx = (*global).Nx+1
  Ny = (*global).Ny
  
  Xfactor = (*global).Xfactor
  Yfactor = (*global).Yfactor
  
  tvimg_bank3 = rebin(bank3_sum_transpose,Nx*Xfactor, Ny*Yfactor,/sample)
  
  ;plot data
  ;top bank = bank3
  view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  tvscl, tvimg_bank3, /NAN
END


;------------------------------------------------------------------------------
PRO bss_reduction_PlotBank4, Event
  ;get global structure
  id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
  widget_control,id,get_uvalue=global
  
  bank4_sum = (*(*global).bank4_sum)
  
  ;transpose data
  bank4_sum_transpose = transpose(bank4_sum)
  
  ;rebin data
  Nx = (*global).Nx+1
  Ny = (*global).Ny
  
  Xfactor = (*global).Xfactor
  Yfactor = (*global).Yfactor
  
  tvimg_bank4 = rebin(bank4_sum_transpose,Nx*Xfactor, Ny*Yfactor,/sample)
  
  ;plot data
  ;top bank = bank4
  view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
  WIDGET_CONTROL, view_info, GET_VALUE=id
  wset, id
  
  tvscl, tvimg_bank4, /NAN
END

;+
; :Description:
;    This will display the bank selected
;
; :Params:
;    Event
;    success
;
;
;
; :Author: j35
;-
PRO bss_reduction_PlotBanks, Event, success

  widget_control,event.top,get_uvalue=global
  
  banks_displayed = (*global).banks_displayed
  
  if (banks_displayed eq 'north_3_4') then begin
  
    banka = (*(*global).bank3)
    bankb = (*(*global).bank4)
    
  endif else begin
  
    banka = (*(*global).bank1)
    bankb = (*(*global).bank2)
    
  endelse
  
  tof_array = banka(*,0,0)
  NbTOF = (size(tof_array))(1)
  (*global).NBTOF = NbTOF
  
  ;sum over TOF
  banka_sum = total(banka,1)
  bankb_sum = total(bankb,1)
  
  ;remove useless last rack
  banka_sum = banka_sum(0:63,0:56) ;the last column will be to be sure we use
  bankb_sum = bankb_sum(0:63,0:56) ;the same z-axis scale (min and max)
  
  max1 = max(banka_sum)
  max2 = max(bankb_sum)
  max = max([max1,max2])
  
  banka_sum[0,56] = max
  bankb_sum[0,56] = max
  
  lin_log_data, event, banka_sum
  lin_log_data, event, bankb_sum
  
  if (banks_displayed eq 'south_1_2') then begin
  
    ;store banks sum
    (*(*global).bank1_sum) = banka_sum
    (*(*global).bank2_sum) = bankb_sum
    
    DEVICE, DECOMPOSED = 0
    bss_reduction_PlotBank1, Event
    bss_reduction_PlotBank2, Event
    
  endif else begin
  
    ;store banks sum
    (*(*global).bank3_sum) = banka_sum
    (*(*global).bank4_sum) = bankb_sum
    
    DEVICE, DECOMPOSED = 0
    bss_reduction_PlotBank3, Event
    bss_reduction_PlotBank4, Event
    
  endelse
  
  ;plot grid
  PlotBanksGrid, Event
  
  success = 1
  
PlotIncludedPixels, event
BSSreduction_PlotCountsVsTofOfSelection_light, Event
BSSreduction_DisplayLinLogFullCountsVsTof, Event

END



pro lin_log_data, event, data
  compile_opt idl2
  
  widget_control,event.top,get_uvalue=global
  plot_type = (*global).plot_type
  
  if (plot_type eq 'log') then begin
  
    ;remove 0 values and replace with NAN
    ;and calculate log
    index = where(Data eq 0, nbr)
    if (nbr GT 0) then begin
      Data[index] = !VALUES.D_NAN
    endif
    Data = ALOG10(Data)
    Data = BYTSCL(Data,/NAN)
    
  endif
  
end