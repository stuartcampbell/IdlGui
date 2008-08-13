pro MAIN_BASE_event, Event

  wWidget =  Event.top  ;widget id
  
  case Event.id of
  
    Widget_Info(wWidget, FIND_BY_UNAME='MAIN_BASE'): begin
      print, "ha!!000000000000000000000000000000"
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='button1'): begin
      loadFile, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='graph'): begin
      graph, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtPath'): begin
      txtPath, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtX'): begin
      txtX, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='txtY'): begin
      txtY, Event
    end
    
    Widget_Info(wWidget, FIND_BY_UNAME='draw1'): begin
      draw, Event
    end
    
    else:
  endcase
  
end






pro MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;define parameters
  scr_x 	= 1100				;main window width
  scr_y 	= 700				;main window height
  ctrl_x	= 1				;width of left box - control
  ctrl_y	= scr_y				;height of lect box - control
  draw_x 	= 304				;main width of draw area
  draw_y 	= 256				;main heigth of draw area
  draw_offset_x = 10			;draw x offset within widget
  draw_offset_y = 10			;draw y offset within widget
  plot_height = 150			;plot box height
  plot_length = 304			;plot box length
  
  APPLICATION = 'plotASCII'
  VERSION     = '1.0'
  
  Resolve_Routine, 'plotMP_eventcb',/COMPILE_FULL_FILE
  ;Load event callback routines
  
  title = APPLICATION + ' - ' + VERSION
  
  MAIN_BASE = Widget_Base( GROUP_LEADER=wGroup,$
    UNAME          = 'MAIN_BASE',$
    XOFFSET        = 500,$
    YOFFSET        = 50,$
    SCR_XSIZE      = scr_x,$
    SCR_YSIZE      = scr_y,$
    ;                         NOTIFY_REALIZE = 'MAIN_REALIZE',$
    TITLE          = title,$
    SPACE          = 3,$
    XPAD           = 3,$
    YPAD           = 3,$
    MBAR           = WID_BASE_0_MBAR)
    
  ;define initial global values
  global = ptr_new({path: '',$
    data: ptr_new(), $
    x: '', $
    y: ''})
    
  loadFile = widget_button(MAIN_BASE,$
    xoffset = 444,$
    yoffset = 4,$
    scr_xsize = 100,$
    scr_ysize = 26,$
    value = 'Browse',$
    uname = 'button1')
    
  graph = widget_button(MAIN_BASE,$
    xoffset = 444,$
    yoffset = 40,$
    scr_xsize = 100,$
    scr_ysize = 26,$
    value = 'Graph',$
    uname = 'graph')
    
  Label1 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 2,$
    yoffset = 4,$
    scr_xsize = 140,$
    scr_ysize = 30,$
    value = 'Select mapping File:',$
    uname = 'label1')
    
  Label2 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 2,$
    yoffset = 40,$
    scr_xsize = 140,$
    scr_ysize = 30,$
    value = '#X pixels/bank:',$
    uname = 'label2')
    
  Label3 = widget_label(MAIN_BASE,$
    /ALIGN_LEFT, $
    xoffset = 2,$
    yoffset = 70,$
    scr_xsize = 140,$
    scr_ysize = 30,$
    value = '#Y pixels/bank:',$
    uname = 'label3')
    
  txtPath = WIDGET_TEXT(MAIN_BASE,$
    xoffset = 142,$
    yoffset = 3,$
    scr_xsize = 300,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtPath')
    
  txtX= WIDGET_TEXT(MAIN_BASE,$
    xoffset = 142,$
    yoffset = 40,$
    scr_xsize = 300,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtX')
    
  txtY= WIDGET_TEXT(MAIN_BASE,$
    xoffset = 142,$
    yoffset = 70,$
    scr_xsize = 300,$
    scr_ysize = 30,$
    /NO_NEWLINE, $
    /EDITABLE, $
    uname = 'txtY')
  wDraw = WIDGET_DRAW(MAIN_BASE,$
    xoffset = 1,$
    yoffset = 200,$
    scr_xsize = 700,$
    scr_ysize = 200,$
    /BUTTON_EVENTS, $
    uname = 'draw1')
    
  ;attach global data structure with widget ID of widget main base widget ID
  widget_control,MAIN_BASE,set_uvalue=global
  
  
  Widget_Control, /REALIZE, MAIN_BASE
  XManager, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ;remove, debug purpose
  tmp = '/SNS/users/dfp/IdlGui/branches/Summer2008/PlotMP/REF_L_TS_2006_12_01.dat'
  widget_control, txtPath, set_value = tmp
  widget_control, txtX, set_value = '304'
  widget_control, txtY, set_value = '256'
  widget_control, txtPath, /INPUT_FOCUS
  ;remove, debug purpose
  
end

;
; Empty stub procedure used for autoloading.
;
pro plotMP, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  MAIN_BASE, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
