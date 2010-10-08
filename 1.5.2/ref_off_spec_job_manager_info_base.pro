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

FUNCTION job_manager_info_base, event

  id = WIDGET_INFO(Event.top,FIND_BY_UNAME='MAIN_BASE')
  ;get global structure
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
  
  ;our_group = widget_base(
  job_base = WIDGET_BASE(GROUP_LEADER=id,$
    /MODAL,$
    /COLUMN,$
    /BASE_ALIGN_CENTER,$
    frame = 10,$
    title = 'LOADING JOB MANAGER PAGE ...')
    
  draw = WIDGET_DRAW(job_base,$
    SCR_XSIZE = 265,$
    SCR_YSIZE = 30,$
    UNAME = 'job_manager_splash_draw')
    
  ;    space = WIDGET_LABEL(job_base,$
  ;    VALUE = ' ')
  ;    label = WIDGET_LABEL(job_base,$
  ;;    FONT = '9x15bold',$
  ;    value = 'This message may disapear before seeing the Job Manager Page!')
  ;    space = WIDGET_LABEL(job_base,$
  ;    VALUE = ' ')
    
  WIDGET_CONTROL, job_base, /realize
  WIDGET_CONTROL, job_base, /SHOW
  
  splash = READ_PNG((*global).job_manager_splash_draw)
  mode_id = WIDGET_INFO(job_base, FIND_BY_UNAME='job_manager_splash_draw')
  
  ;mode
  WIDGET_CONTROL, mode_id, GET_VALUE=id
  WSET, id
  TV, splash, 0,0,/true
  
  RETURN, job_base
  
END
