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

;run the driver
PRO run_driver, Event, cmd, FullOutputfileName, TYPE=type
;get global structure
WIDGET_CONTROL, Event.top, GET_UVALUE=global
;get parameters
nexus_file_name = (*global).data_nexus_file_name
tof_slicer_cmd  = (*global).tof_slicer
;build the command line
END

;-------------------------------------------------------------------------------
PRO launch_counts_vs_tof_full_detector_button, Event
;Create the tof base
launch_counts_vs_tof, Event, FullOutputFileName, TYPE='all'
;run the driver
run_driver, Event, FullOutputfileName, TYPE='all'
END

;------------------------------------------------------------------------------
PRO launch_counts_vs_tof_selection_button, Event
;Create the tof base
launch_counts_vs_tof, Event, FullOutputFileName, TYPE='selection'
;run the driver
run_driver, Event, FullOutputfileName, TYPE='selection'
END

;------------------------------------------------------------------------------
PRO launch_counts_vs_tof_monitor_button, Event
;Create the tof base
launch_counts_vs_tof, Event, FullOutputFileName, TYPE='monitor'
;run the driver
run_driver, Event, FullOutputfileName, TYPE='monitor'
END

;-------------------------------------------------------------------------------
PRO launch_counts_vs_tof, Event, FullOutputFileName, TYPE=type
;get global structure
activate_widget, Event, 'MAIN_BASE',0
WIDGET_CONTROL, Event.top, GET_UVALUE=global		
iBase = OBJ_NEW('IDLmakeTOFbase', $
                EVENT  = Event,$
                GLOBAL = global, $
                TYPE   = type)
END
