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
; @author : Erik Watkins
;           (refashioned by j35@ornl.gov)
;
;==============================================================================

;+
; :Description:
;    retrieves the 2D spectrum of the normalization file
;    ex: Array[2,751]
;
; :Params:
;    event
;    norm_nexus   full path of the normalization nexus file
;
;-
function get_normalization_spectrum, event, norm_nexus
  compile_opt idl2
  
  message = ['> Start retrieving normalization spectrum [tof,counts] ... ']
  message = [message, '-> NeXus file name: ' + norm_nexus]
  log_book_update, event, message=message
  
  iNorm = obj_new('IDLnexusUtilities', norm_nexus)
  spectrum = iNorm->get_TOF_counts_data()
  obj_destroy, iNorm
  
  message = ['> Done with retrieving normalization spectrum [tof,counts]']
  sz = size(spectrum)
  message1 = '-> size(spectrum): [' + $
  strcompress(strjoin(sz,','),/remove_all) + ']'
  message = [message, message1]
  log_book_update, event, message=message
  
  return, spectrum
end

;+
; :Description:
;    Trim the spectrum to keep only the TOF range specified
;
; :Params:
;    spectrum
;
; :Keywords:
;    TOFrange    = [TOFmin, TOFmax]
;
;-
function trim_spectrum, event, spectrum, TOFrange=TOFrange
  compile_opt idl2
  
  message = ['> Triming normalization spectrum:']
  
  _TOFmin = TOFrange[0]
  _TOFmax = TOFrange[1]

  message1 = '-> TOFmin: ' + strcompress(_TOFmin,/remove_all)
  message2 = '-> TOFmax: ' + strcompress(_TOFmax,/remove_all) 
  log_book_update, event, message = [message, message1, message2]
  
  list = where(spectrum[0,*] ge _TOFmin and spectrum[0,*] le _TOFmax)
  spectrum = spectrum[*,list]
  spectrum[1,*] = spectrum[1,*]/max(spectrum[1,*]) ;normalize spectrum to 1
  
  sz = size(spectrum)
  message3 = '-> size(spectrum): [' + $
  strcompress(strjoin(sz,','),/remove_all) + ']'
  log_book_update, event, message = [message, message1, message2, message3]
  
  return, spectrum
end

;+
; :Description:
;    Retrieve all the important information from each data nexus files
;    and keep only the range desired
;
; :Params:
;    event
;    filename
;    TOFmin
;    TOFmax
;    PIXmin
;    PIXmax
;
; :Returns:
;   data    structure {data:image, theta:theta, twotheta:twotheta,$
;                      tof:tof, pixels:pixel}
;
;-
function read_nexus, event, filename, TOFmin, TOFmax, PIXmin, PIXmax
  compile_opt idl2

  message = strarr(13)
  i=0
  message[i++] = '> Read data from NeXus ' + filename
  
  iFile = obj_new('IDLnexusUtilities', filename)
  
  ;get data [tof, pixel_x, pixel_y]
  image = iFile->get_y_tof_data()
  sz = size(image)
  message[i++] = '-> retrieved Y vs TOF data [' + $
  strcompress(strjoin(sz,','),/remove_all) + ']'
  
  ;get tof array only
  tof = iFile->get_TOF_data()
  sz = size(tof)
  message[i++] = '-> retrived tof axis data [' + $
  strcompress(strjoin(sz,','),/remove_all) + ']'
  
  ;get angles
  _Theta = iFile->get_theta()
  _TwoTheta = iFile->get_twoTheta()

  theta = _theta.value
  twotheta = _twotheta.value

  theta_units = _theta.units
  twotheta_units = _twotheta.units
  
  message[i++] = '-> retrieved theta: ' + strcompress(theta,/remove_all) + $
  ' ' + strcompress(theta_units,/remove_all)
  message[i++] = '-> retrieved twotheta: ' + strcompress(twotheta,/remove_all) + $
  ' ' + strcompress(twotheta_units,/remove_all)

  obj_destroy, iFile
  
  Theta=theta+4.0
  TwoTheta=TwoTheta+4.0
  
  message[i++] = '-> Adding 4.0 to theta and twotheta'
  message[i++] = '  -> theta: ' + strcompress(theta,/remove_all) + $
   ' ' + strcompress(theta_units,/remove_all)
  message[i++] = '  -> twotheta: ' + strcompress(twotheta,/remove_all) + $
    ' ' + strcompress(twotheta_units,/remove_all)

  ;Determine where is the first and last tof in the range
  list=where(TOF ge TOFmin and TOF le TOFmax)
  t1=min(where(TOF ge TOFmin))
  t2=max(where(TOF le TOFmax))

  message[i++] = '-> [t1,t2]=[' + strcompress(t1,/remove_all) + $
  ',' + strcompress(t2,/remove_all) + ']'
  
  pixels=findgen(256)
  p1=min(where(pixels ge PIXmin))
  p2=max(where(pixels le PIXmax))
  
  message[i++] = '-> [p1,p2]=[' + strcompress(p1,/remove_all) + $
  ',' + strcompress(p2,/remove_all) + ']'

  TOF=TOF[t1:t2]
  PIXELS=pixels[p1:p2]
  
  image=image[t1:t2,p1:p2]
  
  sz = size(tof)
  message[i++] = '-> size(TOF): ' + strcompress(strjoin(sz,','),/remove_all)   
  sz = size(pixels)
  message[i++] = '-> size(pixels): ' + strcompress(strjoin(sz,','),/remove_all)
  sz = size(image)
  message[i++] = '-> size(image): ' + strcompress(strjoin(sz,','),/remove_all)
  
  ;image -> data (counts)
  ;tof   -> tof axis
  ;pixels -> list of pixels to keep in calculation
  DATA={data:image, theta:theta, twotheta:twotheta, tof:tof, pixels:pixels}

  log_book_update, event, message = message

  return, DATA
  
end

;+
; :Description:
;    Start the heart of the program
;
; :Params:
;    event
;
;-
pro go_reduction, event
  compile_opt idl2
  
  widget_control, event.top, get_uvalue=global
  
  message = ['> Running reduction: ']
  
  widget_control, /hourglass
  show_progress_bar, event
  total_number_of_processes = 10
  processes = 0
  
  message = [message, '-> Retrieving parameters.']
  log_book_update, event, message=message

  ;Retrieve variables
  
  list_data_nexus = (*(*global).list_data_nexus)
  norm_nexus      = (*global).norm_nexus
  
  QZmax = get_ranges_qz_max(event)
  QZmin = get_ranges_qz_min(event)
  QZrange = [QZmin, QZmax]
  
  QXbins = get_bins_qx(event)
  QZbins = get_bins_qz(event)
  
  QXmin = get_ranges_qx_min(event)
  QXmax = get_ranges_qx_max(event)
  QXrange = [QXmin, QXmax]
  
  TOFmin = get_tof_min(event)
  TOFmax = get_tof_max(event)
  TOFrange = [TOFmin, TOFmax]
  
  PIXmin = get_pixel_min(event)
  PIXmax = get_pixel_max(event)
  
  center_pixel = get_center_pixel(event)
  pixel_size = get_pixel_size(event)
  
  SD_d = get_d_sd(event)
  MD_d = get_d_md(event)
  
  update_progress_bar_percentage, event, ++processes, total_number_of_processes
  
  ;create spectrum of normalization file
  spectrum = get_normalization_spectrum(event, norm_nexus)

  update_progress_bar_percentage, event, ++processes, total_number_of_processes
  
  ;trip the spectrum to the relevant tof ranges
  spectrum = trim_spectrum(event, spectrum, TOFrange=TOFrange)
  
  ;prepare array of data coming from the data Nexus files
  file_num = n_elements(list_data_nexus)
  fdig=make_array(file_num)
  
  ;determine the Nexus file(s) which include(s) the critical reflection
  ;all other tiles will be normalized to these.
  file_angles=make_array(3,file_num) ;[file_index, theta, twotheta]
  for read_loop=0,file_num-1 do begin
    ;check to see if the theta value is the same as CE_theta
    DATA = read_nexus(event, $
    list_data_nexus[read_loop], $
    TOFmin, $
    TOFmax, $
    PIXmin, $
    PIXmax)
    ;round the angles to the nearset 100th of a degree
    file_angles[0,read_loop]=read_loop
    file_angles[1,read_loop]=round(DATA.theta*100.0)/100.0
    file_angles[2,read_loop]=round(DATA.twotheta*100.0)/100.0
    
    update_progress_bar_percentage, event, ++processes, $
    total_number_of_processes
    
  endfor
  
  
  
  
  hide_progress_bar, event
  widget_control, hourglass=0
  
end