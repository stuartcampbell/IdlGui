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
FUNCTION get_file_name, file_name_full
file_name_array = STRSPLIT(file_name_full,':',/EXTRACT)
file_name       = STRCOMPRESS(file_name_array[1],/REMOVE_ALL)
RETURN, file_name
END

;------------------------------------------------------------------------------
PRO make_root, Event, wTree, wRoot, date, uname, $
               EXPANDED_STATUS=expanded_status
wRoot = WIDGET_TREE(wTree,$
                    /FOLDER,$
                    /EXPANDED,$
                    VALUE = date,$
                    UNAME = uname)
;                    /TOP)
END

;------------------------------------------------------------------------------
PRO make_leaf, Event, wRoot, file_name
  WIDGET_CONTROL,Event.top,GET_UVALUE=global
 IF (FILE_TEST(file_name)) THEN BEGIN
     icon = (*(*global).icon_ok)
 ENDIF ELSE BEGIN
     icon = (*(*global).icon_failed)
 ENDELSE
wTree = WIDGET_TREE(wRoot,$
                    value = file_name,$
                    BITMAP = icon)
END

;******************************************************************************
;***** Class constructor ******************************************************
FUNCTION IDLrefreshRoot::init, Event, index
WIDGET_CONTROL,Event.top,GET_UVALUE=global

job_status_root_id = (*(*global).job_status_root_id)
widget_control, job_status_root_id[index], /DESTROY

pMetadata        = (*(*global).pMetadata)
job_status_uname = (*(*global).job_status_uname)

;recovering root id
wRoot = job_status_root_id[index]
wTree = (*global).TreeID

uname = job_status_uname[index]
make_root, Event, $
  wTree, $
  wRoot, $
  (*pMetadata)[index].date, $
  uname,$
  EXPANDED_STATUS = 1
;WIDGET_CONTROL, /REALIZE, Event.top     
    
job_status_root_id[index] = wRoot
(*(*global).job_status_root_id) = job_status_root_id

nbr_files = N_ELEMENTS(*(*pMetadata)[index].files)
i = 0
WHILE (i LT nbr_files) DO BEGIN
    file_name = get_file_name((*(*pMetadata)[index].files)[i])
    make_leaf, Event, wRoot, file_name
;    WIDGET_CONTROL, /REALIZE, Event.top
    i++
ENDWHILE

RETURN, 1

END


;******************************************************************************
;******  Class Define *********************************************************
PRO IDLrefreshRoot__define
struct = {IDLrefreshRoot,$
          var: ''}
END
;******************************************************************************
;******************************************************************************
