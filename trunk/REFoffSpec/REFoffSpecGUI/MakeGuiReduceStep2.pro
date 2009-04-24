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

PRO make_gui_Reduce_step2, REDUCE_TAB, sTab, TabTitles, global

  ;******************************************************************************
  ;            DEFINE STRUCTURE
  ;******************************************************************************

  sBase = { size:  stab.size,$
    uname: 'reduce_step2_tab_base',$
    title: TabTitles.step2}
    
  ;******************************************************************************
  ;            BUILD GUI
  ;******************************************************************************
    
  Base = WIDGET_BASE(REDUCE_TAB,$
    UNAME     = sBase.uname,$
    XOFFSET   = sBase.size[0],$
    YOFFSET   = sBase.size[1],$
    SCR_XSIZE = sBase.size[2],$
    SCR_YSIZE = sBase.size[3],$
    TITLE     = sBase.title)
  
    xoff = 50
    
  ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = 30+xoff,$
    YOFFSET = 5,$
    VALUE = 'Normalization File Input')
    
      ;title of normalization input frame
  label = WIDGET_LABEL(Base,$
    XOFFSET = 780+xoff,$
    YOFFSET = 5,$
    VALUE = 'Polarization Mode')
    
  ;first Row
  main_row1 = WIDGET_BASE(Base,$
  XOFFSET = 10,$
  YOFFSET = 20,$
  /ROW)

  ;space
  space = WIDGET_LABEL(main_row1,$
  VALUE = '      ')
    
  ;Loand normalization
  base_row1 = WIDGET_BASE(main_row1,$
    /ROW,$
;    XOFFSET = 10,$
;    YOFFSET = 20,$
    FRAME = 1)
    
  col1 = WIDGET_BASE(base_row1,$
    /COLUMN)
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')

  value = WIDGET_LABEL(col1,$
    VALUE = '')

  browse_button = WIDGET_BUTTON(col1,$
    UNAME = 'reduce_step2_browse_button',$
    VALUE = 'BROWSE ...')
    
  value = WIDGET_LABEL(col1,$
    VALUE = '')

  value = WIDGET_LABEL(col1,$
    VALUE = 'OR')
    
      value = WIDGET_LABEL(col1,$
    VALUE = '')
    
  row2 = WIDGET_BASE(col1,$
    /ROW)
    
  value = WIDGET_LABEL(row2,$
    VALUE = 'Run(s) #:')
    
  text = WIDGET_TEXT(row2,$
    VALUE = '',$
    UNAME = 'reduce_step2_normalization_text_field',$
    XSIZE = 20)
    
  value = WIDGET_LABEL(row2,$
    VALUE = '(ex: 1245,1345-1347,1349)')
    
  label = WIDGET_LABEL(row2,$
    VALUE = '     List of Proposal:')
  ComboBox = WIDGET_COMBOBOX(Row2,$
    VALUE = '                         ',$
    UNAME = 'reduce_tab1_list_of_proposal')
    
;space between base of first row
    space = WIDGET_LABEL(main_row1,$
    VALUE = '      ')
    
;Polarization buttons/base
col2 = WIDGET_BASE(main_row1,$
FRAME = 1,$
/ROW)

button1 = WIDGET_draw(col2,$
uname = 'reduce_step2_polarization_mode1_draw',$
SCR_XSIZE = 200,$
SCR_YSIZE = 145)
    
    space = WIDGET_LABEL(col2,$
    VALUE = '')
    
button2 = WIDGET_draw(col2,$
uname = 'reduce_step2_polarization_mode2_draw',$
SCR_XSIZE = 200,$
SCR_YSIZE = 145)
    
    
END
