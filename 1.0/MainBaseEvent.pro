PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): BEGIN
    END

;'Run #' cw_field in INPUT base
    widget_info(wWidget, FIND_BY_UNAME='run_number'): begin
        InputRunNumber, Event ;in plot_arcs_Input.pro
        ActivateHistoMappingBasesStatus, Event ;in plot_arcs_GUIupdate.pro
    end
    
;'BROWSE EVENT FILE' button in INPUT base
    widget_info(wWidget, FIND_BY_UNAME='browse_event_file_button'): begin
        BrowseEventRunNumber, Event ;in plot_arcs_Browse.pro
        ActivateHistoMappingBasesStatus, Event ;in plot_arcs_GUIupdate.pro
    end

;'Event File' widget_text in INPUT base
    widget_info(wWidget, FIND_BY_UNAME='event_file'): begin
        print, 'in event file text field'
    end


    ELSE:
    
ENDCASE

END
