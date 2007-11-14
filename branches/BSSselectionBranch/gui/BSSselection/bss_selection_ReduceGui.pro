PRO BSSselection_EnableOrNotFields, Event, type

;Value of button
ActivateStatus = isButtonSelected(Event,type)

CASE (type) OF
    'tibc_for_sd_button': BEGIN
        text_unames = ['tibc_for_sd_value_text','tibc_for_sd_error_text']
    END
    'tibc_for_bd_button': BEGIN
        text_unames = ['tibc_for_bd_value_text','tibc_for_bd_error_text']
    END
    'tibc_for_nd_button': BEGIN
        text_unames = ['tibc_for_nd_value_text','tibc_for_nd_error_text']
    END
    'tibc_for_ecd_button': BEGIN
        text_unames = ['tibc_for_ecd_value_text','tibc_for_ecd_error_text']
    END
    'tzsp_button': BEGIN
        text_unames = ['tzsp_value_text','tzsp_error_text']
    END
    'tzop_button': BEGIN
        text_unames = ['tzop_value_text','tzop_error_text']
    END
    'eha_button': BEGIN
        text_unames = ['eha_min_text','eha_max_text', 'eha_bin_text']
    END
    'gifw_button': BEGIN
        text_unames = ['gifw_value_text','gifw_error_text']
    END
    'wocpsamn_button': BEGIN
        text_unames = ['wa_min_text','wa_max_text','wa_bin_width_text']
        activate_button, Event, 'wa_label', ActivateStatus
    END
ENDCASE

new_text_unames = [text_unames,text_unames + '_label']

sz=(size(new_text_unames))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, Event, new_text_unames[i], ActivateStatus
ENDFOR

END




;This procedure upate the GUI
PRO BSSselection_ReduceUpdateGui, Event

;If there is a normalization run then activate in tab3
;Normalization Integration Start and End Wavelength (Angstroms)
NDFiles = getTextFieldValue(Event,'ndf_list_of_runs_text')
IF (NDFiles NE '') THEN BEGIN ;activate widgets
    activate_status = 1
ENDIF ELSE BEGIN ;desactivate widgets
    activate_status = 0
ENDELSE

widgets = ['nisw_field','niew_field']
widgets = [widgets,widgets + '_label','niw_label']
sz = (size(widgets))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, Event, widgets[i], activate_status
ENDFOR

;If dsback is not null, then activate in tab3
;Low and High values that bracket the elastic peak
DSBFiles = getTextFieldValue(Event,'dsb_list_of_runs_text')
IF (DSBFiles NE '') THEN BEGIN ;activate widgets
    activate_status = 1
ENDIF ELSE BEGIN ;desactivate widgets
    activate_status = 0
ENDELSE
widgets = ['te_low_field','te_high_field']
widgets = [widgets,widgets + '_label','te_label']
sz = (size(widgets))(1)
FOR i=0,(sz-1) DO BEGIN
    activate_button, Event, widgets[i], activate_status
ENDFOR


END

