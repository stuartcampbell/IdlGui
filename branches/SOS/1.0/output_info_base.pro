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
;   main base event
;
; :Params:
;   Event
;
; :Author: j35
;-
pro output_info_base_event, Event
  compile_opt idl2
  
  ;get global structure
  widget_control,event.top,get_uvalue=global_plot
  main_event = (*global_plot).main_event
  
  case Event.id of
  
    else:
    
  endcase
  
end

pro output_info_base_gui, wBase, $
    parent_base_geometry
  compile_opt idl2
  
  main_base_xoffset = parent_base_geometry.xoffset
  main_base_yoffset = parent_base_geometry.yoffset
  main_base_xsize = parent_base_geometry.xsize
  main_base_ysize = parent_base_geometry.ysize
  
;  xsize = 300
;  ysize = 100
  
  xoffset = main_base_xsize/2
  xoffset += main_base_xoffset
  
  yoffset = main_base_yoffset+100
  
  ourGroup = WIDGET_BASE()
  
  title = 'Output info selection file/plots'
  wBase = WIDGET_BASE(TITLE = title, $
    UNAME        = 'output_info_base', $
    XOFFSET      = xoffset,$
    YOFFSET      = yoffset,$
    MAP          = 1,$
    kill_notify  = 'output_info_base_killed', $
    /column,$
    /modal, $
    /tlb_size_events,$
    GROUP_LEADER = ourGroup)
    
 
end

;+
; :Description:
;    Killed routine
;    
; :Params:
;    id
;
;
;
; :Author: j35
;-
pro output_info_base_killed, id
  compile_opt idl2
  
  catch, error
  if (error ne 0) then begin
  catch,/cancel
  return
  endif
  
  ;get global structure
  widget_control,id,get_uvalue=global_info
  event = (*global_info).parent_event
  refresh_plot, event

end

;+
; :Description:
;    Cleanup routine
;
; :Params:
;    tlb
;
; :Author: j35
;-
pro counts_info_base_cleanup, tlb
compile_opt idl2

widget_control, tlb, get_uvalue=global_info, /no_copy

  if (n_elements(global_info) eq 0) then return
  
  ptr_free, global_info

end

;+
; :Description:
;   base that will show the x, y, counts values
;   as well as the counts vs tof and counts vs pixel of cursor
;   position
;
; :Keywords:
;    main_base
;    event
;
; :Author: j35
;-
pro output_info_base, event=event, $
    parent_base_uname = parent_base_uname, $
    output_folder = output_folder
  compile_opt idl2
  
  id = WIDGET_INFO(Event.top, FIND_BY_UNAME=parent_base_uname)
  WIDGET_CONTROL,Event.top,GET_UVALUE=global_plot
  parent_base_geometry = WIDGET_INFO(id,/GEOMETRY)
  
  _base = ''
  output_info_base_gui, _base, $
    parent_base_geometry, $
    output_folder = output_folder
    
  WIDGET_CONTROL, _base, /REALIZE
  
  global_info = PTR_NEW({ _base: _base,$
    parent_event: event, $
    output_folder: output_folder, $
    global: global_plot })
    
  WIDGET_CONTROL, _base, SET_UVALUE = global_info
  
  XMANAGER, "output_info_base", _base, GROUP_LEADER = ourGroup, /NO_BLOCK, $
  cleanup='output_info_base_cleanup'
  
end

