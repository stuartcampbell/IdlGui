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

PRO main_base_event, Event

  ;get global structure
  wWidget = Event.top          ;widget id
  widget_control, wWidget, get_uvalue=global
  
  case (Event.id) of
  
    widget_info(wWidget, find_by_uname='main_base'): begin
    end
    
    ;MENU
    ;view log book button
    widget_info(wWidget, find_by_uname='view_log_book_switch'): begin
    
      view_log_book_id = (*global).view_log_book_id
      if (widget_info(view_log_book_id, /valid_id) eq 0) then begin
        groupID = widget_info(event.top, find_by_uname='main_base')
        
        id = widget_info(wWidget, find_by_uname='main_base')
        geometry = widget_info(id,/geometry)
        
        main_base_xoffset = geometry.xoffset
        main_base_yoffset = geometry.yoffset
        main_base_xsize = geometry.xsize
        
        xoffset = main_base_xoffset + main_base_xsize
        yoffset = main_base_yoffset
        
        text = (*(*global).full_log_book)
        
        xdisplayfile, 'LogBook', $
          text=text,$
          height = 70,$
          title='Live Log Book',$
          group = groupID, $
          wtext=view_log_book_id, $
          xoffset = xoffset, $
          yoffset = yoffset
        (*global).view_log_book_id = view_log_book_id
        
      endif
      
    end
    
    ;tab event
    widget_info(wWidget, find_by_uname='tab_uname'): begin
      tab_id = widget_info(event.top,find_by_uname='tab_uname')
      CurrTabSelect = widget_info(tab_id,/tab_current)
      PrevTabSelect = (*global).PrevTabSelect
      if (CurrTabSelect ne PrevTabSelect) then begin
        check_go_button, event=event
        (*global).PrevTabSelect = CurrTabSelect
      endif
      
    end
    
    ;TAB1
    ;Data run numbers text field
    widget_info(wWidget, find_by_uname='data_run_numbers_text_field'): begin
      widget_control, /hourglass
      data_run_numbers_event, event
      clear_text_field, event=event, uname='data_run_numbers_text_field'
      ;retrieve distances from first data nexus file loaded
      retrieve_data_nexus_distances, event=event
      widget_control, hourglass=0
      check_go_button, event=event
    end
    
    ;Browse data button
    widget_info(wWidget, find_by_uname='data_browse_button'): begin
      browse_data_button_event, event
      ;retrieve distances from first data nexus file loaded
      retrieve_data_nexus_distances, event=event
      check_go_button, event=event
    end
    
    ;Normalization run number text field
    widget_info(wWidget, find_by_uname='norm_run_numbers_text_field'): begin
      widget_control, /hourglass
      norm_run_number_event, event
      widget_control, hourglass=0
      clear_text_field, event=event, uname='norm_run_numbers_text_field'
      check_go_button, event=event
    end
    
    ;Browse norm button
    widget_info(wWidget, find_by_uname='norm_browse_button'): begin
      browse_norm_button_event, event
      check_go_button, event=event
    end
    
    ;use same or not normalization files
    widget_info(wWidget, find_by_uname='same_normalization_file_button'): begin
      refresh_big_table, event=event
    end
    widget_info(wWidget, $
      find_by_uname='not_same_normalization_file_button'): begin
      refresh_big_table, event=event
    end
    
    ;interaction with table
    widget_info(wWidget, find_by_uname='tab1_table'): begin
    
      ;select entire rows of selection
      select_entire_row, event=event
      
      if (tag_names(event, /structure_name) EQ 'WIDGET_CONTEXT') THEN BEGIN
        if (selected_row_data_not_empty(event)) then begin
        
          selection = get_table_lines_selected(event=event)
          nbr_row_selected = selection[3]-selection[1]
          ;only 1 row selected
          if (nbr_row_selected eq 0) then begin
            delete_label = 'Delete selected row'
          endif else begin
            delete_label = 'Delete selected rows'
          endelse
          putValue, event=event, 'table_delete_row', delete_label
          
          id = widget_info(event.top, find_by_uname='context_base')
          widget_displaycontextmenu, event.id, event.X, event.Y, id
        endif
      endif
    end
    
    ;select another normalization file
    widget_info(wWidget, find_by_uname='select_another_norm_file'): begin
      selection = get_table_lines_selected(event=event)
      from_row = selection[1]
      to_row = selection[3]
      normalization_selection_base, event=event, $
        main_base_uname='main_base', $
        from_row = from_row, $
        to_row = to_row
    end
    
    ;delete row
    widget_info(wWidget, find_by_uname='table_delete_row'): begin
      delete_row_tab1_table, event
    end
    
    ;--- tab2 (work with rtof) ----
    
    ;rtof text field
    widget_info(wWidget, find_by_uname='rtof_file_text_field_uname'): begin
      check_rtof_buttons_status, event
      check_go_button, event=event
    end
    
    ;load button
    widget_info(wWidget, find_by_uname='load_rtof_file_button'): begin
      file_name = getvalue(event=event, uname='rtof_file_text_field_uname')
      file_name = strtrim(file_name,2)
      file_name = file_name[0]
      result = load_rtof_file(event, file_name)
      result = load_geometry_parameters(event)
      check_rtof_buttons_status, event
      check_go_button, event=event
    end
    
    ;nexus file to use for geometry
    widget_info(wWidget, find_by_uname='rtof_nexus_geometry_file'): begin
      check_rtof_buttons_status, event
      check_go_button, event=event
      result = load_geometry_parameters(event)
    end
    
    ;browse for nexus file
    widget_info(wWidget, find_by_uname='rtof_nexus_geometry_button'): begin
      browse_for_rtof_nexus_file, event
      check_rtof_buttons_status, event
      check_go_button, event=event
      result = load_geometry_parameters(event)
    end
    
    ;---- bottom part of GUI ----------
    
    ;full reset
    widget_info(wWidget, find_by_uname='full_reset'): begin
      full_reset, event
    end
    
    ;GO REDUCTION
    widget_info(wWidget, find_by_uname='go_button'): begin
      tab_id = widget_info(event.top,find_by_uname='tab_uname')
      CurrTabSelect = widget_info(tab_id,/tab_current)
      case (CurrTabSelect) of
        0: begin ;working with NeXus
          go_nexus_reduction, event
        end
        1: begin ;working with rtof
          go_rtof_reduction, event
        end
        else:
      endcase
      
    end
    
    else:
  endcase
  
end

