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

PRO  ActivateWidget, Event, uname, ActivateStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, sensitive=ActivateStatus
END

;------------------------------------------------------------------------------
PRO MapBase, Event, uname, MapStatus
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, map=MapStatus
END

;------------------------------------------------------------------------------
PRO SetCWBgroup, Event, uname, value
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=value
END

;------------------------------------------------------------------------------
PRO SetButtonValue, Event, uname, text
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=text
END

;------------------------------------------------------------------------------
PRO SetTabCurrent, Event, uname, TabIndex
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_tab_current=TabIndex
END

;------------------------------------------------------------------------------
PRO SetDropListValue, Event, uname, index
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_droplist_select=index
END

;------------------------------------------------------------------------------
PRO SetSliderValue, Event, uname, index
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, set_value=index
END

;------------------------------------------------------------------------------
;This procedure allows the text to show the last 2 lines of the Data
;log book
PRO showLastDataLogBookLine, Event
dataLogBook = getDataLogBookText(Event)
sz = (size(dataLogBook))(1)
id = widget_info(Event.top,find_by_uname='data_log_book_text_field')
widget_control, id, set_text_top_line=(sz-2)
END

;------------------------------------------------------------------------------
;This procedure allows the text to show the last 2 lines of the Norm
;log book
PRO showLastNormLogBookLine, Event
NormLogBook = getNormalizationLogBookText(Event)
sz = (size(NormLogBook))(1)
id = widget_info(Event.top,find_by_uname='normalization_log_book_text_field')
widget_control, id, set_text_top_line=(sz-2)
END

;------------------------------------------------------------------------------
PRO SetBaseYSize, Event, uname, y_size
id = widget_info(Event.top,find_by_uname=uname)
widget_control, id, YSIZE = y_size
END

;------------------------------------------------------------------------------
;This function hide or not the Normalization base of the REDUCE tab
PRO NormReducePartGuiStatus, Event, status
id_group = WIDGET_INFO(Event.top,FIND_BY_UNAME='yes_no_normalization_bgroup')
id_base  = WIDGET_INFO(Event.top,FIND_BY_UNAME='normalization_base')

CASE (status) OF
    'show': BEGIN
        group_value = 0
        base_value  = 1
    END
    'hide': BEGIN
        group_value = 1
        base_value  = 0
    END
ELSE:
ENDCASE

WIDGET_CONTROL, id_group, SET_VALUE=group_value
WIDGET_CONTROL, id_base, MAP=base_value

END

;------------------------------------------------------------------------------
;This function activates or not the REPOPULATE GUI button
PRO RepopulateButtonStatus, Event, status
id = WIDGET_INFO(Event.top,FIND_BY_UNAME='repopulate_gui')
WIDGET_CONTROL, id, sensitive=status
END
