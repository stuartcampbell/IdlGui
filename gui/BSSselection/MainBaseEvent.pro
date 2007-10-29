PRO MAIN_BASE_event, Event
 
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

wWidget =  Event.top            ;widget id

CASE Event.id OF
    
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
    end

;cw_field run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number'): begin
        bss_selection_LoadNexus, Event
    end

;BROWSE button run number
    Widget_Info(wWidget, FIND_BY_UNAME='nexus_run_number_button'): begin
        bss_selection_BrowseNexus, Event
    end
    
;counts vs tof draw
    widget_info(wWidget, FIND_BY_UNAME='counts_vs_tof_draw'): begin
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded

            if (Event.release EQ 1) then begin ;mouse released
                BSSselection_ZoomInCountsVsTofReleased, Event
            endif
            
            if (Event.press EQ 1) then begin ;mouse pressed
                if (Event.type EQ 0 ) then begin ;left click
                    BSSselection_ZoomInCountsVsTofPressed, Event
                endif

            endif

          endif
            
        end
    
;X: Y: Bank: and PixelID cw_fields       
;X
    Widget_Info(wWidget, FIND_BY_UNAME='x_value'): begin
              BSSselection_DisplayCountsVsTof, Event
              BSSselection_UpdatePixelIDField, Event
    end

;Y        
    Widget_Info(wWidget, FIND_BY_UNAME='y_value'): begin
              BSSselection_DisplayCountsVsTof, Event
              BSSselection_UpdatePixelIDField, Event
    end

;Bank
    Widget_Info(wWidget, FIND_BY_UNAME='bank_value'): begin
              BSSselection_DisplayCountsVsTof, Event
              BSSselection_UpdatePixelIDField, Event
    end

;PixelID
    Widget_Info(wWidget, FIND_BY_UNAME='pixel_value'): begin
              BSSselection_DisplayCountsVsTof, Event
              BSSselection_UpdateXYBankFields, Event
    end


;bank1 widget_draw
    widget_info(wWidget, FIND_BY_UNAME='top_bank_draw'): begin
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
            BSSselection_DisplayXYBankPixelInfo, Event, 'bank1'
            if( Event.type EQ 0 )then begin
                if (Event.press EQ 1) then $ ;left click
                  BSSselection_DisplayCountsVsTof, Event
                if (Event.press EQ 4) then $ 
                  BSSselection_IncludeExcludePixel, Event
            endif
        endif
    end
    
;bank2 widget_draw
    widget_info(wWidget, FIND_BY_UNAME='bottom_bank_draw'): begin
        if ((*global).NeXusFound) then begin ;only if there is a NeXus loaded
            BSSselection_DisplayXYBankPixelInfo, Event, 'bank2'
            if( Event.type EQ 0 )then begin
                if (Event.press EQ 1) then $ ;left click
                  BSSselection_DisplayCountsVsTof, Event
                if (Event.press EQ 4) then $ 
                  BSSselection_IncludeExcludePixel, Event
            endif
        endif
    end
    
;EXCLUDE pixelID
    Widget_Info(wWidget, FIND_BY_UNAME='exclude_pixelid'): begin
        BSSselection_ExcludePixelid, Event
    end

;INCLUDE pixelID
    Widget_Info(wWidget, FIND_BY_UNAME='include_pixelid'): begin
        BSSselection_IncludePixelid, Event
    end


;EXCLUDE row of pixels
    Widget_Info(wWidget, FIND_BY_UNAME='exclude_pixel_row'): begin
        BSSselection_ExcludePixelRow, Event
    end

;INCLUDE row of pixels
    Widget_Info(wWidget, FIND_BY_UNAME='include_pixel_row'): begin
        BSSselection_IncludePixelRow, Event
    end


;EXCLUDE tubes
    Widget_Info(wWidget, FIND_BY_UNAME='exclude_tube'): begin
        BSSselection_ExcludeTube, Event
    end

;INCLUDE tubes
    Widget_Info(wWidget, FIND_BY_UNAME='include_tube'): begin
        BSSselection_IncludeTube, Event
    end

    ELSE:
    
ENDCASE

END
