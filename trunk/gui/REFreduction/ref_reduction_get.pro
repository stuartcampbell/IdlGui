;This function returns the contain of the Text Field
FUNCTION getTextFieldValue, Event, uname
TextFieldID = widget_info(Event.top,find_by_uname=uname)
widget_control, TextFieldID, get_value = TextFieldValue
RETURN, TextFieldValue
END


;This function returns the contain of the Main Log Book text field
FUNCTION getLogBookText, Event
return, getTextFieldValue(Event,'log_book_text_field')
END


;This function returns the contain of the Data Log Book text field
FUNCTION getDataLogBookText, Event
return, getTextFieldValue(Event, 'data_log_book_text_field')
END


;This function returns the contain of the Normalization Log Book text field
FUNCTION getNormalizationLogBookText, Event
return, getTextFieldValue(Event, 'normalization_log_book_text_field')
END


;This function returns the result of cw_bgroup
FUNCTION getCWBgroupValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
return, value
END
