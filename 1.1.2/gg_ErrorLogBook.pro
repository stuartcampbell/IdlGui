PRO displayErrorLogBook, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
logText = (*global).error_log_book
putInTextField, Event, 'error_text_field', logText
END
