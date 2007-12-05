PRO gg_Browse, Event, type

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

CASE (type) OF
    'geometry':BEGIN
        filter = (*global).geometry_xml_filtering
        path   = (*global).geometry_default_path
        title  = 'Select a geometry.xml file'
    END
    'cvinfo':BEGIN
        filter = (*global).cvinfo_xml_filtering
        path   = (*global).cvinfo_default_path
        title  = 'Select a cvinfo.xml file'
    END
    ELSE:BEGIN
        filter = ''
    END
ENDCASE

IF (filter NE '') THEN BEGIN
    
    default_extension = (*global).default_extension
    full_file_name = DIALOG_PICKFILE(DEFAULT_EXTENSION = default_extension,$
                                     FILTER            = filter,$
                                     TITLE             = title,$
                                     PATH              = path,$
                                     /MUST_EXIST)
    
    IF (full_file_name NE '') THEN BEGIN
        putFileNameInTextField, Event, type, full_file_name
    ENDIF
    
ENDIF



END
