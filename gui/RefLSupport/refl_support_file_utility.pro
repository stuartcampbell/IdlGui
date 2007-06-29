;This function checks if the newly loaded file has alredy
;been loaded. Return 1 if yes and 0 if not
FUNCTION isFileAlreadyInList, ListOfFiles, file
sizeArray = size(ListOfFiles)
size = sizeArray[1]
for i=0, (size-1) do begin
    if (ListOfFiles[i] EQ file) then begin
        return, 1
    endif
endfor
return, 0
end


;this function return 1 if the ListOfFiles is empty (first load)
;otherwise it returns 0
FUNCTION isListOfFilesSize0, ListOfFiles
sizeArray = size(ListOfFiles)
if (sizeArray[1] EQ 1) then begin
    ;check if argument is empty string
    if (ListOfFiles[0] EQ '') then begin
        return, 1
    endif else begin
        return, 0
    endelse
endif else begin
    return, 0
endelse
end


;This function remove the short file name and keep
;the path and reset the default working path
Function DEFINE_NEW_DEFAULT_WORKING_PATH, Event, file
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
path = get_path_to_file_name(file)
(*global).input_path = path ;reset the default path
return, path
end


;this function display the OPEN FILE from IDL
;get global structure
Function OPEN_FILE, Event
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
title    = 'Select file:'
filter   = '*' + (*global).file_extension
pid_path = (*global).input_path
;open file
FullFileName = dialog_pickfile(path=pid_path,$
                               get_path=path,$
                               title=title,$
                               filter=filter)
;redefine the working path
path = define_new_default_working_path(Event,FullFileName)
return, FullFileName
end


;This functions populate the various droplist boxes
;It also checks if the newly file loaded is not already 
;present in the list, in this case, it's not added
PRO add_new_file_to_droplist, Event, ShortFileName, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
ListOfFiles = (*(*global).list_of_files)
ListOfLongFileName = (*(*global).ListOfLongFileName)
if (isListOfFilesSize0(ListOfFiles) EQ 1) then begin
    ListOfFiles = [ShortFileName]
    ListOfLongFileName = [LongFileName]
endif else begin
    if(isFileAlreadyInList(ListOfFiles,ShortFileName) EQ 0) then begin ;true newly file
        ListOfFiles = [ListOfFiles,ShortFileName]
        ListOfLongFileName = [ListOfLongFileName,LongFileName]
    endif
endelse
(*(*global).list_of_files) = ListOfFiles
(*(*global).ListOfLongFileName) = ListOfLongFileName
;update list of file in droplist of step1
list_of_files_droplist_id = widget_info(Event.top,find_by_uname='list_of_files_droplist')
widget_control, list_of_files_droplist_id, set_value=ListOfFiles
;update list of file in droplist of step2
base_file_droplist_id = widget_info(Event.top,find_by_uname='base_file_droplist')
widget_control, base_file_droplist_id, set_value=ListOfFiles
;update list of file in droplists of step3
step3_base_file_droplist_id = widget_info(Event.top,find_by_uname='step3_base_file_droplist')
widget_control, step3_base_file_droplist_id, set_value=ListOfFiles
step3_work_on_file_droplist_id = widget_info(Event.top,find_by_uname='step3_work_on_file_droplist')
widget_control, step3_work_on_file_droplist_id, set_value=ListOfFiles
end


;This functions displays the first few lines of the newly loaded file
PRO display_info_about_selected_file, Event, LongFileName
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global
no_file = 0
nbr_line = fix(20) ;nbr of lines to display
catch, no_file
if (no_file NE 0) then begin
    plot_file_found = 0    
endif else begin
    openr,u,LongFileName,/get
    fs = fstat(u)
;define an empty string variable to hold results from reading the file
    tmp = ''
    while (NOT eof(u)) do begin
        readu,u,onebyte         ;,format='(a1)'
        fs = fstat(u)
        if fs.cur_ptr EQ 0 then begin
            point_lun,u,0
        endif else begin
            point_lun,u,fs.cur_ptr - 4
        endelse
        info_array = strarr(nbr_line)
        for i=0,(nbr_line) do begin
            readf,u,tmp
            info_array[i] = tmp
        endfor
    endwhile
    close,u
    free_lun,u
endelse
;populate text box with array
TextBoxId = widget_info(Event.top,FIND_BY_UNAME='file_info')
widget_control, TextBoxId, set_value=info_array[0]
for i=1,(nbr_line-1) do begin
    widget_control, TextBoxId, set_value=info_array[i],/append
endfor
end



