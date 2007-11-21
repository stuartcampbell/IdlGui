PRO BSSselection_LoadNexus_step2, Event, NexusFullName

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing
OK = (*global).ok
FAILED = (*global).failed

;display full name of nexus in his label
PutNexusNameInLabel, Event, NexusFullName

message = '  -> NeXus file location: ' + NexusFullName
AppendLogBookMessage, Event, message

;retrieve bank1 and bank2
message = '  -> Retrieving bank1 and bank2 data ... ' + PROCESSING
AppendLogBookMessage, Event, message
retrieveBanksData, Event, strcompress(NexusFullName,/remove_all)
putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot bank1 and bank2
message = '  -> Plot bank1 and bank2 ... ' + PROCESSING
AppendLogBookMessage, Event, message

success = 0
bss_selection_PlotBanks, Event, success

if (success EQ 0) then begin

    putTextAtEndOfLogBookLastLine, Event, FAILED, PROCESSING

;desactivate button
    activate_status = 0

endif else begin

    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;plot counts vs TOF of full selection
    message = '  -> Plot Counts vs TOF of full selection ... ' + PROCESSING
    AppendLogBookMessage, Event, message
    BSSselection_PlotCountsVsTofOfSelection, Event
    putTextAtEndOfLogBookLastLine, Event, OK, PROCESSING

;populate ROI file name
    BSSselection_CreateRoiFileName, Event
;activate button
    activate_status = 1

endelse

;activate or not 'save_roi_file_button', 'roi_path_button',
;'roi_file_name_generator', 'load_roi_file_button'
activate_button, event, 'load_roi_file_button', activate_status
activate_button, event, 'save_roi_file_button', activate_status
activate_button, event, 'roi_path_button', activate_status
activate_button, event, 'roi_file_name_generator', activate_status

END    
