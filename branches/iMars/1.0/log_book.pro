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

;+
; :Description:
;    Display the log book
;
; :Params:
;    event
;
;
;
; :Author: j35
;-
pro display_log_book, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  log_book = (*(*global).log_book)
  
  id = widget_info(event.top, find_by_uname='MAIN_BASE')
  geometry = widget_info(id, /geometry)
  xsize = geometry.xsize
  ysize = geometry.ysize
  xoffset = geometry.xoffset
  yoffset = geometry.yoffset
  
  xdisplayfile, '',$
    title='Log Book',$
    width=50,$
    height=50,$
    xoffset = xsize+xoffset,$
    yoffset = yoffset,$
    group=id,$
    text=log_book,$
    return_id=log_book_id
    
  (*global).log_book_id = log_book_id  
    
end

;+
; :Description:
;    This procedure adds the message given to the log book and display it
;    if the log book is enabled
;
; :Keywords:
;    event
;    message
;
; :Author: j35
;-
pro add_to_log_book, event=event, message=message
compile_opt idl2

widget_control, event.top, get_uvalue=global

log_book = (*(*global).log_book)

;;steal code from SOS here

if (widget_info((*global).log_book_id, /valid_id)) then begin
display_log_book, event
endif 





end
