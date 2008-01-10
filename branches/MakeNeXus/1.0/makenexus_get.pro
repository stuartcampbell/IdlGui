FUNCTION getRunNumber, Event
id = widget_info(Event.top,find_by_uname='run_number_cw_field')
widget_control, id, get_value=RunNumber
RETURN, strcompress(RunNumber,/remove_all)
END


;-------------------------------------------------------------------------------
FUNCTION StringSplit, delimiter, text
RETURN, strsplit(text, delimiter,/extract)
END

FUNCTION CreateList, text2
ON_IOERROR, L1 ;in case one of the variable can't be converted
;into an int
FixText2 = Fix(Text2)
min = MIN(FixText2,MAX=max)
list = lonarr(1)
list[0] = min
FOR i=1,(max-min) DO BEGIN
    list = [list,min+i]
ENDFOR
RETURN, list
return, [val1,val2]
L1: return, ''
END

FUNCTION getListOfRuns, RunNumber
;parse according to ','
text1 = StringSplit(',',RunNumber)
;parse accordint to '-'
sz = (size(text1))(1)
FOR i=0,(sz-1) DO BEGIN
    text2 = StringSplit('-',text1[i])
    sz = (size(text2))(1)
    IF (sz GT 1) THEN BEGIN ;'10-15'
        list_to_add = CreateList(text2)
        IF (list_to_add NE [''] OR $
            list_to_add[0] EQ 0) THEN BEGIN
            list_to_add = string(list_to_add)
            IF (i EQ 0) THEN BEGIN ;only for first iteration
                List = list_to_add
            ENDIF ELSE BEGIN
                List = [List, list_to_add]
            ENDELSE
        ENDIF
    ENDIF ELSE BEGIN ;10
        IF (i EQ 0) THEN BEGIN ;only for first iteration
            List = text2
        ENDIF ELSE BEGIN
            List = [List, text2]
        ENDELSE
    ENDELSE
ENDFOR
return, strcompress(List,/remove_all)
END
;-------------------------------------------------------------------------------


FUNCTION getInstrument, Event
;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
id = widget_info(Event.top,find_by_uname='instrument_droplist')
index = widget_info(id, /droplist_select)
instrumentShortList = (*(*global).instrumentShortList)
RETURN, instrumentShortList[index]
END

FUNCTION getOutputPath, Event
id = widget_info(Event.top,find_by_uname='output_path_text')
widget_control, id, get_value=outputPath
RETURN,strcompress(outputPath,/remove_all)
END

FUNCTION getLogBookText, Event
id = widget_info(Event.top,find_by_uname='log_book')
widget_control, id, get_value=text
RETURN, text
END

FUNCTION getMyLogBookText, Event
id = widget_info(Event.top,find_by_uname='my_log_book')
widget_control, id, get_value=text
RETURN, text
END

FUNCTION getTextFieldValue, Event, uname
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, get_value=value
RETURN, value
END

FUNCTION getProposalNumber, Event, prenexus_path
textSplit = strsplit(prenexus_path,'/',/extract)
RETURN, textSplit[1]
END


FUNCTION getNbrPolaState, Event, file_name
IF (!VERSION.os EQ 'darwin') THEN BEGIN
    return, 1
ENDIF ELSE BEGIN
    oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=file_name)
    no_error = 0
    CATCH, no_error
    IF (no_error NE 0) THEN BEGIN
        return, 0
    ENDIF ELSE BEGIN
        oDocList = oDoc->GetElementsByTagName('DetectorInfo')
        obj1 = oDocList->item(0)
        obj2=obj1->GetElementsByTagName('States')
        obj3=obj2->item(0)
        obj3b=obj3->getattributes()
        obj3c=obj3b->getnameditem('number')
        return, fix(obj3c->getvalue())
    ENDELSE
ENDELSE
END
