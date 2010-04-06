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

PRO populate_data_geometry_info, Event, nexus_file_name

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  iNexus = obj_new('NeXusMetadata', nexus_file_name)
  
  ;get date and put it in place
  date = iNexus->getDate()
  putTextFieldValue, event, 'info_date', date
  
  ;get start
  start_time = iNexus->getStart()
  putTextFieldValue, event, 'info_start', start_time
  
  ;get end
  end_time = iNexus->getEnd()
  putTextFieldValue, event, 'info_end', end_time
  
  ;get duration
  duration = iNexus->getDuration()
  putTextFieldValue, event, 'info_duration', duration[0]
  
  ;proton charge
  proton_charge = iNexus->getProtonCharge()
  putTextfieldValue, event, 'info_proton_charge', proton_Charge[0]
  
  ;bin size
  bin_size = iNexus->getBinSize()
  putTextFieldValue, event, 'info_bin_size', bin_size[0]
  
  ;Dangle
  dangle_value = iNexus->getDangle()
  dangle = dangle_value[0] + ' degrees (' + dangle_value[1] + ' rad)'
  
  putTextFieldValue, event, 'info_dangle', dangle
  
  ;Dangle0
  dangle0_value = iNexus->getDangle0()
  dangle0 = dangle0_value[0] + ' degrees (' + dangle0_value[1] + ' rad)'
  putTextFieldValue, event, 'info_dangle0', dangle0
  
  ;dirpix
  dirpix = iNexus->getDirpix()
  putTextFieldValue, event, 'info_dirpix', dirpix[0]
  
  ;detector sample distance
  dist_units = iNexus->getSampleDetDistance()
  dist = dist_units[0] + ' ' + dist_units[1]
  putTextFieldValue, event, 'info_detector_sample_distance', dist
  
  obj_destroy, iNexus
  
END

;------------------------------------------------------------------------------
PRO calculate_data_refpix, Event

  WIDGET_CONTROL,Event.top,get_uvalue=global
  
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
    refpix = 'N/A'
  ENDIF ELSE BEGIN
  
    ON_IOERROR, done_calculation
    
    ymin = getTextFieldValue(Event,'data_d_selection_roi_ymin_cw_field')
    ymax = getTextFieldValue(Event,'data_d_selection_roi_ymax_cw_field')
    
    IF (ymin NE 0 AND ymax NE 0) THEN BEGIN
    
      ymin = FLOAT(ymin)
      ymax = FLOAT(ymax)
      refpix = MEAN([ymin,ymax])
      (*global).refpix = refpix
      
    ENDIF ELSE BEGIN
    
      refpix = 'N/A'
      
    ENDELSE
    
    putTextFieldValue, event, 'info_refpix', $
      STRCOMPRESS(refpix,/REMOVE_ALL), 0
      
    calculate_sangle, event
    
    RETURN
    
    done_calculation:
    refpix = 'N/A'
    putTextFieldValue, event, 'info_refpix', $
      STRCOMPRESS(refpix,/REMOVE_ALL), 0
      
  ENDELSE
  
END

;+
; :Description:
;   calculates the sangle value (deg and rad) and display its value in
;   its widget_label in the info (nexus information) of the data loaded
;
; :Params:
;    event
;
; :Author: j35
;-
pro calculate_sangle, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  ;on_ioerror, error
  
  ;retrieve dirpix and refpix
  dirpix = getTextFieldValue(event,'info_dirpix')
  f_dirpix = float(dirpix[0])
  print, 'f_dirpix: ' , f_dirpix
  
  refpix = getTextFieldValue(event,'info_refpix')
  f_refpix = float(refpix[0])
  print, 'f_refpix: ' , f_refpix
  
  ;get distance into metre
  detector_sample_distance = getTextFieldValue(event,$
    'info_detector_sample_distance')
  distance_units = strsplit(detector_sample_distance[0],' ',/extract)
  f_det_sample_distance = convert_to_m(distance_units[0], $
    strcompress(distance_units[1],/remove_all))
  if (f_det_sample_distance eq -1) then message, /ioerror
  print, 'f_det_sample_distance: ' , f_det_sample_distance
  
  ;get dangle and dangle0 in radians
  dangle = getTextFieldValue(event,'info_dangle')
  dangle_rad = get_value_between_arg1_arg2(dangle[0], '\(', 'rad)')
  f_dangle_rad = float(dangle_rad)
  print, 'f_dangle_rad: ' , f_dangle_rad
  
  dangle0 = getTextFieldValue(event,'info_dangle0')
  dangle0_rad = get_value_between_arg1_arg2(dangle0[0], '\(', 'rad)')
  f_dangle0_rad = float(dangle0_rad)
  print, 'f_dangle0_rad: ' , f_dangle0_rad
  
  ;get size of detectors
  det_size_m = float((*global).detector_size_m)
  
  ;do the calculation
  part1 = (f_dangle_rad - f_dangle0_rad)/2.
  part2 = (f_dirpix - 
  
  
  
  error:
  sangle = 'N/A'
  putTextFieldValue, event, 'info_sangle', sangle
  
end
