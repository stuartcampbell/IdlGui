;######################## CHECK - IN UTILITY #######################
;check if it's worth validating exclude and include buttons
PRO BSSselection_IncludeExcludeCheckPixelField, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve text
PixelidText = getSelectionBasePixelidText(Event)
IF (PixelidText[0] NE '' AND (*global).NeXusFound EQ 1) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activate_button, Event, 'exclude_pixelid', activate_status
activate_button, Event, 'include_pixelid', activate_status
END



PRO BSSselection_IncludeExcludeCheckPixelRowField, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;retrieve text
RowText = getSelectionBaseRowText(Event)
IF (RowText[0] NE '' AND (*global).NeXusFound EQ 1) THEN BEGIN
    activate_status = 1
ENDIF ELSE BEGIN
    activate_status = 0
ENDELSE
activate_button, Event, 'exclude_pixel_row', activate_status
activate_button, Event, 'include_pixel_row', activate_status
END



;Exclude Pixelid
PRO BSSselection_ExcludePixelid, Event

;retrieve text
PixelidText = getSelectionBasePixelidText(Event)

;create list of pixelids
PixelidList = RetrieveList(PixelidText)

;convert list to integer
PixelidListInt = ConvertListToInt(PixelidList)

;add list of pixels to exclude list
AddListToExcludeList, Event, PixelidListInt

;add excluded pixel to bank1 and bank2
PlotExcludedPixels, Event

;remove contents of cw_field
ResetSelectionBasePixelidText, Event

END



;Include Pixelid
PRO BSSselection_IncludePixelid, Event

;retrieve text
PixelidText = getSelectionBasePixelidText(Event)

;create list of pixelids
PixelidList = RetrieveList(PixelidText)

;convert list to integer
PixelidListInt = ConvertListToInt(PixelidList)

;Remove list of pixels to exclude list
RemoveListToExcludeList, Event, PixelidListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotIncludedPixels, Event

;remove contents of cw_field
ResetSelectionBasePixelidText, Event

END



;Exclude Pixel Row
PRO BSSselection_ExcludePixelRow, Event

;retrieve text
RowText = getSelectionBaseRowText(Event)

;create list of row
RowList = RetrieveList(RowText)

;convert list to integer
RowListInt = ConvertListToInt(RowList)

;Remove list of pixels to exclude list
RemoveRowToExcludeList, Event, RowListInt

;remove pixel to list of excluded pixels for bank1 and bank2
PlotExcludedPixels, Event

;remove contents of cw_field
ResetSelectionBaseRowText, Event


END














PRO BSSselection_IncludePixelRow, Event
END


;Tube
PRO BSSselection_ExcludeTube, Event
END

PRO BSSselection_IncludeTube, Event
END
