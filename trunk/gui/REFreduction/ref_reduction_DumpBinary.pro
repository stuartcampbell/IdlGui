;**********************************************************************
;DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA - DATA  *
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinaryData, Event, full_nexus_name, destination_folder

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_file_name = (*global).data_tmp_dat_file

RefReduction_DumpBinary, $
  Event, $
  full_nexus_name, $
  destination_folder, $
  tmp_file_name

END



;**********************************************************************
;NORMALIZATION - NORMALIZATION - NORMALIZATION - NORMALIZATION        *
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinaryNormalization, Event, full_nexus_name, destination_folder

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

tmp_file_name = (*global).norm_tmp_dat_file

RefReduction_DumpBinary, $
  Event, $
  full_nexus_name, $
  destination_folder, $
  tmp_file_name

END



;**********************************************************************
;DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA - DUMP_DATA*
;**********************************************************************
;This function dumps the binary data of the given full nexus name
PRO RefReduction_DumpBinary, Event, full_nexus_name, destination_folder, tmp_file_name

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

PROCESSING = (*global).processing_message ;processing message

cmd_dump = 'nxdir ' + full_nexus_name
cmd_dump += ' -p /entry/bank1/data/ --dump ' 
cmd_dump += (*global).working_path + tmp_file_name
cmd_dump_text = cmd_dump + '........' + PROCESSING

;display in log book what is going on
cmd_dump_text = '        > ' + cmd_dump_text
putLogBookMessage, Event, cmd_dump_text, Append=1

;run command
spawn, cmd_dump, listening

;tells user that dump is done
LogBookText = getLogBookText(Event)
Message = 'OK'
putTextAtEndOfLogBookLastLine, Event, LogBookText, Message, PROCESSING

END
