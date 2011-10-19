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

PRO MakeGuiReduceInputTab1, ReduceInputTab, ReduceInputTabSettings

  tab1_base = WIDGET_BASE(ReduceInputTab,$
    TITLE     = ReduceInputTabSettings.title[0])
    
  yoffset = 94
  data = widget_label(tab1_base,$
    yoffset = 8,$
    xoffset = 10,$
    value = 'Raw Sample Data File')
  back = widget_label(tab1_base,$
  
    yoffset = 8+yoffset+30  ,$
    xoffset = 10,$
    
    value = 'Background Data File')
  yoffset = 75+15
  norm = widget_label(tab1_base,$
    yoffset = 26+2*yoffset,$
    xoffset = 10,$
    value = 'Normalization Data File')
  ec = widget_label(tab1_base,$
    yoffset = 10+3*yoffset,$
    xoffset = 10,$
    value = 'Empty Can Data File')
  bk = widget_label(tab1_base,$
    yoffset = 83 + 3*yoffset,$
    xoffset = 10,$
    value = 'Direct Scattering Background (Sample Data at Baseline T) File')
    
  col_base = widget_base(tab1_base,$
    /column)
    
  ;\\\\\\\\\\\\\\\\\\\\\
  ;Raw Sample Data File\
  ;\\\\\\\\\\\\\\\\\\\\\
  space = widget_label(col_base,$
    value = ' ',scr_ysize=10)
  data_base = widget_base(col_base,$
    /column,$
    frame=4)
  row1 = widget_base(data_base,/row)
  field1 = cw_field(row1,$
    xsize=110,$
    /return_events,$
    uname='rsdf_run_number_cw_field',$
    title='Run #')
    
  ;use live or not
  row2 = widget_base(data_base,/row)
  live_base = widget_base(row2,/row,sensitive=0,uname='reduce_tab1_live_base')
  live = cw_bgroup(live_base,$
    /no_release, $
    ['Yes','No'],$
    label_left = 'Use live NeXus loaded:',$
    uname = 'use_live_nexus_uname',$
    /row,$
    set_value=1,$
    /exclusive)
  label=widget_label(row2,value='                                        ' + $
    '   (ex: 1,2,[3,5-8],10) -> 4 diff. jobs')
  ;  button = widget_button(row1,$
  ;    value='Browse ...',$
  ;    uname='rsdf_browse_nexus_button',$
  ;    scr_xsize=120)
  ;  list = widget_text(data_base,$
  ;    scr_xsize=719,$
  ;    /editable,$
  ;    uname='rsdf_list_of_runs_text')
    
  space = widget_label(col_base,value=' ',scr_ysize=10)
  
  ;/////////////////////
  ;Background Data File/
  ;/////////////////////
  data_base = widget_base(col_base,$
    /column,$
    frame=4)
  row1 = widget_base(data_base,/row)
  browse = widget_button(row1,$
  value='Browse...',$
  uname='bdf_browse_nexus_button')
  list = widget_text(row1,$
  xsize=84,$
  /editable,$
  /all_events,$
  uname='bdf_list_of_runs_text')
  field1 = cw_field(row1,$
    xsize=10,$
    /return_events,$
    uname='bdf_run_number_cw_field',$
    title='or Run#')
space = widget_label(col_base,value=' ',scr_ysize=10)

  ;////////////////////////
  ;Normalization Data File/
  ;////////////////////////
  data_base = widget_base(col_base,$
    /column,$
    frame=4)
  row1 = widget_base(data_base,/row)
  browse=widget_button(row1,$
  value='Browse...',$
  uname='ndf_browse_nexus_button')
  list = widget_text(row1,$
  xsize=84,$
  /editable,$
  /all_events,$
  uname='ndf_list_of_runs_text')
  field1 = cw_field(row1,$
    xsize=10,$
    /return_events,$
    uname='ndf_run_number_cw_field',$
    title='or Run#')
space = widget_label(col_base,value=' ',scr_ysize=10)
  
  ;////////////////////
  ;Empty Can Data File/
  ;////////////////////
  data_base = widget_base(col_base,$
    /column,$
    frame=4)
  row1 = widget_base(data_base,/row)
  browse = widget_button(row1,$
  value='Browse...',$
  uname='ecdf_browse_nexus_button')
  list = widget_text(row1,$
  xsize=84,$
  /all_events,$
  /editable,$
  uname='ecdf_list_of_runs_text')
  field1 = cw_field(row1,$
    xsize=10,$
    /return_events,$
    uname='ecdf_run_number_cw_field',$
    title='or Run#')
space = widget_label(col_base,value=' ',scr_ysize=10)
  
  ;/////////////////////////////
  ;Direct Scattering background/
  ;/////////////////////////////
  data_base = widget_base(col_base,$
    /column,$
    frame=4)
  row1 = widget_base(data_base,/row)
  browse=widget_button(row1,$
  value='Browse...',$
  uname='dsb_browse_nexus_button')
  list = widget_text(row1,$
  xsize=84,$
  /all_events,$
  /editable,$
  uname='dsb_list_of_runs_text')
  field1 = cw_field(row1,$
    xsize=10,$
    /return_events,$
    uname='dsb_run_number_cw_field',$
    title='or Run#')
  label=widget_label(row1,value='(ex: 1,2,3,5-8,10)')

END
