;This function creates the name of the Data and Normalization
;Background ROI file
PRO REFreduction_CreateDefaultBackgroundROIFileName, Event,$
                                                     instrument,$
                                                     working_path,$
                                                     run_number

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

REFreduction_CreateDefaultDataBackgroundROIFileName, Event,$
  instrument,$
  working_path,$
  run_number

REFreduction_CreateDefaultNormalizationBackgroundROIFileName, Event,$
  instrument,$
  working_path,$
  run_number

END



;This function creates the name of the Data Background ROI file
PRO REFreduction_CreateDefaultDataBackgroundROIFileName, Event,$
                                                         instrument,$
                                                         working_path,$
                                                         run_number


;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

DefaultBackRoiFileName = working_path + instrument
DefaultBackRoiFileName += '_' + run_number
DefaultBackRoiFileName += (*global).data_back_roi_ext

putTextFieldValue, Event,$
  'data_background_selection_file_text_field',$
  DefaultBackRoiFileName,0
  
END



;This function creates the name of the Normalization Background ROI file
PRO REFreduction_CreateDefaultNormalizationBackgroundROIFileName, Event,$
                                                                  instrument,$
                                                                  working_path,$
                                                                  run_number


END
