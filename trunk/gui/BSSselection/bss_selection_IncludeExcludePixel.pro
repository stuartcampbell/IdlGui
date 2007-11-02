PRO PlotExcludedBox, x, y, x_coeff, y_coeff, color
    plots, x*x_coeff, y*y_coeff, /device, color=color
    plots, x*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
    plots, (x+1)*x_coeff, y*y_coeff, /device, color=color
    plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
    
    plots, x*x_coeff,y*y_coeff, /device,color=color
    plots, (x+1)*x_coeff, y*y_coeff, /device, /continue, color=color
    plots, x*x_coeff,(y+1)*y_coeff, /device,color=color
    plots, (x+1)*x_coeff, (y+1)*y_coeff, /device, /continue, color=color
END



PRO BSSselection_IncludeExcludePixel, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;clear contain of message box
putMessageBoxInfo, Event, ''

;retrieve bank, x and y infos
bank    = getBankValue(Event)
PixelID = getPixelIDvalue(Event)

pixel_excluded = (*(*global).pixel_excluded)

IF (pixel_excluded(PixelID)) THEN BEGIN
    new_state = 0
ENDIF ELSE BEGIN
    new_state = 1
ENDELSE
pixel_excluded(PixelID) = new_state
(*(*global).pixel_excluded) = pixel_excluded

IF (bank EQ 1) THEN BEGIN       ;bank 1
    view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
ENDIF ELSE BEGIN                ;bank 2    
    view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
ENDELSE

WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id
x_coeff = (*global).Xfactor
y_coeff = (*global).Yfactor
color   = (*global).ColorExcludedPixels

IF (new_state) THEN BEGIN ;exclude pixel
    x       = getXValue(Event)
    y       = getYValue(Event)
    PlotExcludedBox, x, y, x_coeff, y_coeff, color
ENDIF ELSE BEGIN                ;include pixel

;first replot bank + lines
    IF (bank EQ 1) THEN BEGIN ;bank1
        bss_selection_PlotBank1, Event
        PlotBank1Grid, Event
        pixelid_min = 0L
    ENDIF ELSE BEGIN
        bss_selection_PlotBank2, Event
        PlotBank2Grid, Event
        pixelid_min = 4096L
    ENDELSE
    
;replot all the pixelID excluded
    FOR i = 0, 3584L DO BEGIN
        pixel = pixelid_min + i
        IF (pixel_excluded(pixel) EQ 1) THEN BEGIN ;plot lines around this pixel
            XY = getXYfromPixelID(Event, pixel)
            PlotExcludedBox, XY[0], XY[1], x_coeff, y_coeff, color
        ENDIF        
    ENDFOR

ENDELSE

END






PRO PlotExcludedPixels, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

x_coeff = (*global).Xfactor
y_coeff = (*global).Yfactor
color   = (*global).ColorExcludedPixels

view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

pixel_excluded = (*(*global).pixel_excluded)
FOR i=0,3584L DO BEGIN
    IF (pixel_excluded[i] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, i)
        PlotExcludedBox, XY[0], XY[1], x_coeff, y_coeff, color
    ENDIF
ENDFOR

view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

pixelid_min = 4096L
FOR i=0,3584L DO BEGIN
    pixel = pixelid_min + i    
    IF (pixel_excluded[pixel] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, pixel)
        PlotExcludedBox, XY[0], XY[1], x_coeff, y_coeff, color
    ENDIF
ENDFOR
END





PRO PlotIncludedPixels, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

x_coeff = (*global).Xfactor
y_coeff = (*global).Yfactor
color   = (*global).ColorExcludedPixels

;plot main plots + grid
bss_selection_PlotBank1, Event
PlotBank1Grid, Event
bss_selection_PlotBank2, Event
PlotBank2Grid, Event

view_info = widget_info(Event.top,FIND_BY_UNAME='top_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

pixel_excluded = (*(*global).pixel_excluded)
FOR i=0,3584L DO BEGIN
    IF (pixel_excluded[i] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, i)
        PlotExcludedBox, XY[0], XY[1], x_coeff, y_coeff, color
    ENDIF
ENDFOR

view_info = widget_info(Event.top,FIND_BY_UNAME='bottom_bank_draw')
WIDGET_CONTROL, view_info, GET_VALUE=id
wset, id

pixelid_min = 4096L
FOR i=0,3584L DO BEGIN
    pixel = pixelid_min + i    
    IF (pixel_excluded[pixel] EQ 1) THEN BEGIN
        XY = getXYfromPixelID(Event, pixel)
        PlotExcludedBox, XY[0], XY[1], x_coeff, y_coeff, color
    ENDIF
ENDFOR
END





PRO BSSselection_FullResetButton, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

pixel_excluded = intarr((*global).pixel_excluded_size)
(*(*global).pixel_excluded) = pixel_excluded

PlotIncludedPixels, Event

LogBookText = '-> ROI has been fully reset.'
AppendLogBookMessage, Event, LogBookText

;remove name of file loaded from Loaded ROI text
putLoadedRoiFileName, Event, ''

END
