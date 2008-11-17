;==============================================================================
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
; CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE.
;
; Copyright (c) 2006, Spallation Neutron Source, Oak Ridge National Lab,
; Oak Ridge, TN 37831 USA
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; - Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
; - Redistributions in binary form must reproduce the above copyright notice,
;   this list of conditions and the following disclaimer in the documentation
;   and/or other materials provided with the distribution.
; - Neither the name of the Spallation Neutron Source, Oak Ridge National
;   Laboratory nor the names of its contributors may be used to endorse or
;   promote products derived from this software without specific prior written
;   permission.
;
; @author : j35 (bilheuxjm@ornl.gov)
;
;==============================================================================

FUNCTION addTimeStamp, full_output_file_name
timeStamp = GenerateIsoTimeStamp()
CATCH, no_error
IF (no_error NE 0) THEN BEGIN
    CATCH,/CANCEL
    RETURN, full_output_file_name
ENDIF ELSE BEGIN
;remove extension
    file_array = STRSPLIT(full_output_file_name,'.',/EXTRACT)
    new_file_name = file_array[0] + '_' + timeStamp + '.' + file_array[1]
ENDELSE
RETURN, new_file_name
END

;------------------------------------------------------------------------------
FUNCTION AreAllFilesFound, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global
pMetadata       = (*(*global).pMetadata)
nbr_files       = N_ELEMENTS(*(*pMetadata)[index].files)
i = 0
all_found = 1
WHILE (i LT nbr_files) DO BEGIN
    file_name_full  = (*(*pMetadata)[index].files)[i]
    file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
    file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
    IF (~FILE_TEST(file_name)) THEN BEGIN
        all_found = 0
        BREAK
    ENDIF
    i++
ENDWHILE
RETURN, all_found
END

;------------------------------------------------------------------------------
FUNCTION determine_default_output_file_name, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global
pMetadata       = (*(*global).pMetadata)
file_name_full  = (*(*pMetadata)[index].files)[0]
file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
;keep only first part of file name (BSS_623_Q00.txt)
split_array     = STRSPLIT(file_name,'_',COUNT=nbr)
file_name       = STRMID(file_name,0,split_array[nbr-1])
;add new extension
file_name      += (*global).iter_dependent_back_ext
;file name only
short_file_name = FILE_BASENAME(file_name)
RETURN, short_file_name
END

;------------------------------------------------------------------------------
PRO create_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
widget_control,/hourglass

label = 'REFRESHING LIST OF JOBS ... '
putButtonValue, Event, 'refresh_list_of_jobs_button', label

iJob = OBJ_NEW('IDLreadLogFile',Event)
IF (OBJ_VALID(iJob)) THEN BEGIN
    pMetadata = iJob->getStructure()
    (*(*global).pMetadata) = pMetadata
    pMetadataValue = iJob->getMetadata()
    (*(*global).pMetadataValue) = pMetadataValue
    iDesign = OBJ_NEW('IDLmakeTree', Event, pMetadata)
    OBJ_DESTROY, iDesign
    
;select the first one by default and display value of this one in table
    select_first_node, Event    ;Gui
    display_contain_OF_job_status, Event, 0
    
;put time stamp
    updateRefreshButtonLabel, Event ;_GUI

ENDIF ELSE BEGIN ;error refreshing the config file (clear widget_tree)

    label = 'NO MORE JOBS TO LIST !'
    putButtonValue, Event, 'refresh_list_of_jobs_button', label
    
    error = 0
    CATCH, error
    IF (error NE 0) THEN BEGIN
        CATCH,/CANCEL
    ENDIF ELSE BEGIN
        WIDGET_CONTROL, (*global).TreeID, /DESTROY
    ENDELSE
    
ENDELSE
OBJ_DESTROY, iJob

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO refresh_job_status, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

label = 'REFRESHING LIST OF JOBS ... '
putButtonValue, Event, 'refresh_list_of_jobs_button', label

pMetadata = (*(*global).pMetadata)
iDesign = OBJ_NEW('IDLrefreshTree', Event, pMetadata)
OBJ_DESTROY, iDesign

;put time stamp
updateRefreshButtonLabel, Event ;_GUI

END

;------------------------------------------------------------------------------
PRO display_contain_OF_job_status, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global

aMetadataValue = (*(*(*global).pMetadataValue))
Nbr_metadata  = (size(aMetadataValue))(2)
aTable = STRARR(2,Nbr_metadata)

aTable[0,*] = aMetadataValue[0,*]
aTable[1,*] = aMetadataValue[index+1,*]

putTableValue, Event, 'job_status_table', aTable
FileFoundStatus = AreAllFilesFound(Event, index)

updateJobStatusOutputBase, Event, FileFoundStatus

;determine default output file name
default_output_file_name = determine_default_output_file_name(Event,index)
;put name in output text box
putTextinTextField, Event, $
  'job_status_output_file_name_text_field',$
  default_output_file_name

END

;------------------------------------------------------------------------------
PRO job_status_folder_button, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

title = 'Select a default folder name'
path  = (*global).output_plot_path

result = DIALOG_PICKFILE(TITLE = title,$
                         /DIRECTORY,$
                         /MUST_EXIST,$
                         PATH = path)

IF (result NE '') THEN BEGIN
    SetButton, event, 'job_status_output_path_button', result
    (*global).output_plot_path = result
ENDIF
END
                         
;------------------------------------------------------------------------------
PRO stitch_files, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING = (*global).processing
OK         = (*global).ok
FAILED     = (*global).failed

;build command line
stitch_driver = (*global).stitch_driver

;retrieve list of files
index = (*global).igs_selected_index
pMetadata       = (*(*global).pMetadata)
nbr_files       = N_ELEMENTS(*(*pMetadata)[index].files)
str_OF_files    = ''
i = 0
WHILE (i LT nbr_files) DO BEGIN
    IF (i GT 0) THEN BEGIN
        str_OF_files += ' '
    ENDIF
    file_name_full  = (*(*pMetadata)[index].files)[i]
    file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
    file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
    str_OF_files += file_name 
    i++
ENDWHILE

cmd = stitch_driver
cmd += ' ' + str_OF_files

;add output folder/file name
output_path = getButtonValue(Event,'job_status_output_path_button')
output_file = getTextFieldValue(Event, $
                                'job_status_output_file_name_text_field')
full_output_file_name = output_path + output_file 

;add time_stamp to file_name
full_output_file_name = addTimeStamp(full_output_file_name)

(*global).job_status_full_output_file_name = full_output_file_name
cmd += ' --output=' + full_output_file_name

;check if there is a rescale factor added or not
aMetadata = (*(*(*global).pMetadataValue))
scaling_flag     = STRCOMPRESS(aMetadata[index+1,73],/REMOVE_ALL)
scaling_constant = STRCOMPRESS(aMetadata[index+1,74],/REMOVE_ALL)
IF (scaling_flag EQ 'ON') THEN BEGIN
    IF (scaling_constant NE 'N/A') THEN BEGIN
        cmd += ' --rescale=' + scaling_constant
        stitch_files_step2, Event, cmd
    ENDIF ELSE BEGIN ;popup base that ask for a scaling value
        title = 'Scaling flag is ON but no value attributed to the ' + $
          'scaling value'
        iScaling = OBJ_NEW('IDscalingGUI',Event, scaling_constant,title, cmd)
        OBJ_DESTROY, iScaling
    ENDELSE
ENDIF

IF (scaling_flag EQ 'N/A') THEN BEGIN ;popup base that ask for a scaling value
    title = 'The status of the Scaling Flag/Value is undefined !'
    iScaling = OBJ_NEW('IDLscalingGUI',Event, scaling_constant,title, cmd)
    OBJ_DESTROY, iScaling
ENDIF

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO stitch_files_step2, Event, cmd
WIDGET_CONTROL,Event.top,GET_UVALUE=global

;indicate initialization with hourglass icon
WIDGET_CONTROL,/HOURGLASS

PROCESSING            = (*global).processing
OK                    = (*global).ok
FAILED                = (*global).failed
full_output_file_name = (*global).job_status_full_output_file_name

text = '> Stitching the files:'

AppendLogBookMessage, Event, text
cmd_text = '-> ' + cmd + ' ... ' + PROCESSING
AppendLogBookMessage, Event, cmd_text

spawn, cmd, listening, err_listening
err_listening = ''
IF (err_listening[0] NE '') THEN BEGIN
    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING
ENDIF ELSE BEGIN
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot data
    IF (FILE_TEST(full_output_file_name)) THEN BEGIN
        text = '-> Plotting ' + full_output_file_name
        AppendLogBookMessage, Event, text

;put name of file in text field 0f output tab
        putTextInTextField, Event, 'output_plot_file_name', $
          full_output_file_name
;display metadata of selected file
    display_metadata, Event, full_output_file_name
        
;select OUTPUT tab
    id = WIDGET_INFO(Event.top,FIND_BY_UNAME='main_tab')
    WIDGET_CONTROL, id, SET_TAB_CURRENT=3

    ENDIF ELSE BEGIN

        text = '-> File ' + full_output_file_name + ' can not be found !'
        AppendLogBookMessage, Event, text
        result = DIALOG_MESSAGE('ERROR PLOTTING ' + full_output_file_name,$
                                /ERROR,$
                                /CENTER)
    ENDELSE

ENDELSE

;turn off hourglass
WIDGET_CONTROL,HOURGLASS=0

END

;------------------------------------------------------------------------------
PRO remove_job_status_folder, Event
WIDGET_CONTROL,Event.top,GET_UVALUE=global
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='job_status_tree')
IF (WIDGET_INFO(id, /TREE_SELECT) EQ -1) THEN BEGIN
    result = DIALOG_MESSAGE('Please Select a Folder First!',$
                            /INFORMATION,$
                            /CENTER)
ENDIF ELSE BEGIN
    index_selected = (*global).igs_selected_index
;remove given folder from config file
    iRemove = OBJ_NEW('IDLremoveFolderFromConfig',Event,index_selected)
    OBJ_DESTROY, iRemove
;refresh widget_tree
    create_job_status, Event
ENDELSE
END

;------------------------------------------------------------------------------
PRO browse_list_OF_job, Event
WIDGET_CONTROL, Event.top, GET_UVALUE=global

path  = (*global).output_plot_path
title = 'Select all the files you want to stitch'

list_OF_files = DIALOG_PICKFILE(TITLE  = title,$
                                PATH   = path,$
                                /MUST_EXIST,$
                                FILTER = '*.txt',$
                                /MULTIPLE_FILES)
                         
IF (list_OF_files[0] NE '') THEN BEGIN ;add these files to config file
    
    iFile = OBJ_NEW('IDLaddBrowsedFilesToConfig', Event, list_OF_files)
    IF (OBJ_VALID(iFile)) THEN BEGIN
        create_job_status, Event
        OBJ_DESTROY, iFile
    ENDIF
    
ENDIF

END

