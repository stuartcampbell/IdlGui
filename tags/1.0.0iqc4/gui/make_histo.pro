pro wTLB_event, Event

  wWidget =  Event.top  ;widget id

  case Event.id of

    Widget_Info(wWidget, FIND_BY_UNAME='wTLB'): begin
    end

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_EVENT_FILE_BUTTON_tab1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_EVENT_FILE_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='NUMBER_PIXEL_IDS'): begin
    	NUMBER_PIXEL_IDS_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='REBINNING_TEXT'): begin
    	REBINNING_TEXT_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='MAX_TIME_BIN_TEXT'): begin
    	MAX_TIME_BIN_TEXT_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='OPEN_MAPPING_FILE_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        OPEN_MAPPING_FILE_BUTTON_CB, Event
	end

    Widget_Info(wWidget, FIND_BY_UNAME='DEFAULT_PATH_BUTTON'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        DEFAULT_PATH_BUTTON_CB, Event
	end

    Widget_Info(wWidget, FIND_BY_UNAME='GO_HISTOGRAM_BUTTON_wT1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        GO_HISTOGRAM_CB, Event
    end

    Widget_Info(wWidget, FIND_BY_UNAME='CREATE_NEXUS'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CREATE_NEXUS_CB, Event
    end

    else:
  endcase

end


pro wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

Resolve_Routine, 'make_histo_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

;define initial global values - these could be input via external file or other means

global = ptr_new({$
		path			: '~/CD4/REF_M/REF_M_7/',$
		filter_event		: '*_event.dat',$
		event_filename  	: '',$
		event_filename_only	: '',$
		histo_filename		: '',$
		histo_mapped_filename	: '',$
		mapping_filename	: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_TS_2006_07_25.dat',$
		translation_filename	: '/SNS/REF_M/2006_1_4A_CAL/calibrations/REF_M_2006_08_03.nxt',$
		nexus_filename		: '',$
		new_translation_filename: '',$
		lin_log			: 0L,$
		number_pixels		: 0L,$
		rebinning		: 0L,$
		max_time_bin		: 0L,$
		filter_mapping		: 'REF_M_TS_*.dat',$
		path_mapping		: '/SNS/REF_M/2006_1_4A_CAL/calibrations/' $
		 })

  ; Create the top-level base and the tab.
  wTLB = WIDGET_BASE(GROUP_LEADER=wGroup,UNAME='wTLB',/COLUMN, XOFFSET=50, YOFFSET=450, $
	SCR_XSIZE=500, SCR_YSIZE=280, title="Histogramming - Mapping - Translation")
   wTab = WIDGET_TAB(wTLB, LOCATION=location)

  ; Create the first tab base, containing a label and two
  ; button groups.
  wT1 = WIDGET_BASE(wTab, TITLE='Histogramming',$
	UNAME="wT1",$
	SCR_XSIZE=500, SCR_YSIZE=210)

  OPEN_EVENT_FILE_BUTTON_tab1 = WIDGET_BUTTON(wT1, $
	UNAME="OPEN_EVENT_FILE_BUTTON_tab1",$
	XOFFSET= 10, YOFFSET = 5, $
	SCR_XSIZE=120, SCR_YSIZE=30, $
	VALUE= "Select Event file")
  EVENT_FILE_LABEL_tab1 = WIDGET_TEXT(wT1,$
	UNAME='EVENT_FILE_LABEL_tab1',$
	XOFFSET=135, YOFFSET=5,$
	SCR_XSIZE=358, SCR_YSIZE=30, $
	value = '')

  NUMBER_PIXELIDS_LABEL_tab1 = WIDGET_LABEL(wT1,$
	XOFFSET=8, YOFFSET=40,$
	SCR_XSIZE=130, SCR_YSIZE=30,$
	VALUE='Number of pixel IDs')
  NUMBER_PIXELIDS_TEXT_tab1 = WIDGET_TEXT(wT1,$
	XOFFSET=135, YOFFSET=40,$
	SCR_XSIZE=70, SCR_YSIZE=30,$
	VALUE='77824',$
	/editable,$
	UNAME='NUMBER_PIXEL_IDS',/ALL_EVENTS)

  REBINNING_TYPE_GROUP_wT1 = CW_BGROUP(wT1, ['linear', 'logarithmic'], $
    /ROW, /EXCLUSIVE, /RETURN_NAME,$
	XOFFSET=20, YOFFSET=70,$
	SET_VALUE=0.0,$
	UNAME='REBINNING_TYPE_GROUP')

  left_offset=8
  top_offset=70+30
  REBINNING_LABEL_wT1 = WIDGET_LABEL(wT1, $
	XOFFSET=left_offset, YOFFSET=top_offset,$
	SCR_XSIZE=130, SCR_YSIZE=30,$
	VALUE='Rebin value (microS)')
  REBINNING_TEXT_wT1 = WIDGET_TEXT(wT1,$
	XOFFSET=left_offset+127, YOFFSET=top_offset,$
	SCR_XSIZE=70, SCR_YSIZE=30,$
	VALUE='25', /editable,$
	UNAME='REBINNING_TEXT',/ALL_EVENTS)

  MAX_TIME_BIN_LABEL_wT1 = WIDGET_LABEL(wT1, $
	XOFFSET=left_offset+2, YOFFSET=top_offset+30,$
	SCR_XSIZE=120, SCR_YSIZE=30,$
	VALUE='Max Tstamp (microS)')
  MAX_TIME_BIN_TEXT_wT1 = WIDGET_TEXT(wT1,$
	XOFFSET=left_offset+127, YOFFSET=top_offset+30,$
	SCR_XSIZE=70, SCR_YSIZE=30,$
	VALUE='200000', /editable,$
	UNAME='MAX_TIME_BIN_TEXT',/ALL_EVENTS)

  LEFT_FRAME_wT1 = WIDGET_LABEL(wT1,$
	XOFFSET=5, YOFFSET=37,$
	SCR_XSIZE=200, SCR_YSIZE=130,$
	FRAME=2, value ='')

  GO_HISTOGRAM_BUTTON_wT1 = WIDGET_BUTTON(wT1,$
	XOFFSET=5, YOFFSET=top_offset+75,$
	SCR_XSIZE=200, SCR_YSIZE=30,$
	VALUE='Histogram Data',$
	UNAME='GO_HISTOGRAM_BUTTON_wT1')

  HISTOGRAM_STATUS_wT1 = WIDGET_TEXT(wT1,$
	XOFFSET=215, YOFFSET=37,$
	SCR_XSIZE=275, SCR_YSIZE=165,$
	VALUE='Select event file and check parameters', /scroll,$
	/wrap,$
	UNAME='HISTOGRAM_STATUS')

;  wLabel = WIDGET_LABEL(wT1, VALUE='Choose values')
;  wBgroup1 = CW_BGROUP(wT1, ['one', 'two', 'three'], $
;    /ROW, /NONEXCLUSIVE, /RETURN_NAME)
;  wBgroup2 = CW_BGROUP(wT1, ['red', 'green', 'blue'], $
;    /ROW, /EXCLUSIVE, /RETURN_NAME)

  wT2 = WIDGET_BASE(wTab, TITLE='Mapping and Default Path')

  OPEN_MAPPING_FILE_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 5, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Mapping file",$
	UNAME='OPEN_MAPPING_FILE_BUTTON')
  MAPPING_FILE_LABEL_tab2 = WIDGET_TEXT(wT2,$
	UNAME='MAPPING_FILE_LABEL_tab1',$
	XOFFSET=135, YOFFSET=5,$
	SCR_XSIZE=358, SCR_YSIZE=32, $
	value = (*global).mapping_filename)

  DEFAULT_TRANSLATION_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 45, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Translation file",$
	UNAME='DEFAULT_TRANSLATION_BUTTON')
  DEFAULT_TRANSLATION_FILE_tab2 = WIDGET_TEXT(wT2,$
	UNAME='DEFAULT_TRANSLATION_FILE_tab2',$
	XOFFSET=135, YOFFSET=45,$
	SCR_XSIZE=358, SCR_YSIZE=32, $
	value = (*global).translation_filename)

  DEFAULT_PATH_BUTTON_tab2 = WIDGET_BUTTON(wT2, $
	XOFFSET= 5, YOFFSET = 85, $
	SCR_XSIZE=130, SCR_YSIZE=30, $
	VALUE= "Default final path",$
	UNAME='DEFAULT_PATH_BUTTON')
  DEFAULT_FINAL_PATH_tab2 = WIDGET_TEXT(wT2,$
	UNAME='DEFAULT_FINAL_PATH_tab2',$
	XOFFSET=135, YOFFSET=85,$
	SCR_XSIZE=358, SCR_YSIZE=32, $
	value = '')

;   Create the second tab base, containing a label and
;  a slider.
;  wLabel = WIDGET_LABEL(wT2, VALUE='Move the Slider')
;  wSlider = WIDGET_SLIDER(wT2)

;   Create the third tab base, containing a label and
;  a text-entry field.
;  wT3 = WIDGET_BASE(wTab, TITLE='Default Path', /COLUMN)
;  wLabel = WIDGET_LABEL(wT3, VALUE='Enter some text')
;  wText= WIDGET_TEXT(wT3, /EDITABLE, /ALL_EVENTS)

;   Create a base widget to hold the 'Create NeXus' button, and
;   the button itself.
  wControl = WIDGET_BASE(wTLB)
  CREATE_NEXUS = WIDGET_BUTTON(wControl, VALUE='C R E A T E    N E X U S',$
	UNAME = "CREATE_NEXUS",$
	XOFFSET=10, YOFFSET=5,$
	SCR_XSIZE=480, SCR_YSIZE=30)

;   Realize the widgets, set the user value of the top-level
;  base, and call XMANAGER to manage everything.
  WIDGET_CONTROL, wTLB, /REALIZE
  WIDGET_CONTROL, wTLB, SET_UVALUE=global ;we've used global, not stash as the structure name
  Widget_Control, CREATE_NEXUS, sensitive=0
  Widget_Control, GO_HISTOGRAM_BUTTON_wT1, sensitive=0

 XMANAGER, 'wTLB', wTLB, /NO_BLOCK

end

;
; Empty stub procedure used for autoloading.
;
pro make_histo, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  wTLB, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
