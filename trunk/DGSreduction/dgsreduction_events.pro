;+
; :Copyright:
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
; Copyright (c) 2009, Spallation Neutron Source, Oak Ridge National Lab,
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
; :Author: scu (campbellsi@ornl.gov)
;-

PRO dgsreduction_events, event, dgsr_cmd

  WIDGET_CONTROL, event.id, GET_UVALUE=myUVALUE
  
  ; Check that we actually got something back in the UVALUE
  IF N_ELEMENTS(myUVALUE) EQ 0 THEN myUVALUE="NOTHING"
  
  
  CASE (myUVALUE) OF
    'NOTHING': BEGIN
    END
    'DGSR_DATARUN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DataRun=myValue
    END
    'DGSR_EI': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Ei=myValue
    END
    'DGSR_TZERO': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Tzero=myValue
    END
    'DGSR_DATAPATHS_LOWER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=lowerValue
      dgsr_cmd->SetProperty, LowerBank=lowerValue
    END
    'DGSR_DATAPATHS_UPPER': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=upperValue
      dgsr_cmd->SetProperty, UpperBank=upperValue
    END
    'DGSR_ROI_FILENAME': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsr_cmd->SetProperty, ROIfile=myValue
    END
    'DGSR_MASK': BEGIN
      ;WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsr_cmd->SetProperty, Mask=event.SELECT
    END
    'DGSR_HARD_MASK': BEGIN
      ;WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      ; TODO: Check filename exists before setting the property!
      dgsr_cmd->SetProperty, HardMask=event.SELECT
    END
    'DGSR_MAKE_SPE': BEGIN
      dgsr_cmd->SetProperty, SPE=event.SELECT
    END
    'DGSR_MAKE_QVECTOR': BEGIN
      dgsr_cmd->SetProperty, Qvector=event.SELECT
      fixedGrid_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_MAKE_FIXED')
      ; Make the Fixed Grid output selection active if Qvector is selected.
      WIDGET_CONTROL, fixedGrid_ID, SENSITIVE=event.SELECT
    END
    'DGSR_MAKE_FIXED': BEGIN
      dgsr_cmd->SetProperty, Fixed=event.SELECT
    END
    'DGSR_MAKE_COMBINED_ET': BEGIN
      dgsr_cmd->SetProperty, DumpEt=event.SELECT
    END
    'DGSR_MAKE_COMBINED_TOF': BEGIN
      dgsr_cmd->SetProperty, DumpTOF=event.SELECT
    END
    'DGSR_MAKE_COMBINED_WAVE': BEGIN
      dgsr_cmd->SetProperty, DumpWave=event.SELECT
      ; Also make the wavelength range fields active (or inactive!)
      wavelengthRange_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_COMBINED_WAVELENGTH_RANGE')
      WIDGET_CONTROL, wavelengthRange_ID, SENSITIVE=event.SELECT
    END
    'DGSR_DUMP_TIB': BEGIN
      dgsr_cmd->SetProperty, DumpTIB=event.SELECT
    END
    'DGSR_DUMP_NORM': BEGIN
      dgsr_cmd->SetProperty, DumpNorm=event.SELECT
    END
    'DGSR_ET_MIN': BEGIN
      ; Minimum Energy Transfer
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EnergyBins_Min=myValue
    END
    'DGSR_ET_MAX': BEGIN
      ; Maximum Energy Transfer
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EnergyBins_Max=myValue
    END
    'DGSR_ET_STEP': BEGIN
      ; Energy Transfer Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EnergyBins_Step=myValue
    END
    'DGSR_LAMBDA_MIN': BEGIN
      ; Minimum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, LambdaBins_Min=myValue
    END
    'DGSR_LAMBDA_MAX': BEGIN
      ; Maximum Wavelength
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, LambdaBins_Max=myValue
    END
    'DGSR_LAMBDA_STEP': BEGIN
      ; Wavelength Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, LambdaBins_Step=myValue
    END
    'DGSR_Q_MIN': BEGIN
      ; Minimum Q
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, QBins_Min=myValue
    END
    'DGSR_Q_MAX': BEGIN
      ; Maximum Q
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, QBins_Max=myValue
    END
    'DGSR_Q_STEP': BEGIN
      ; Q Step size
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, QBins_Step=myValue
    END
    'DGSR_NO-MON-NORM': BEGIN
      dgsr_cmd->SetProperty, NoMonitorNorm=event.SELECT
      ; Also make the Proton Charge Norm active
      pcnorm_ID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_PC-NORM')
      WIDGET_CONTROL, pcnorm_ID, SENSITIVE=event.SELECT
    END
    'DGSR_PC-NORM': BEGIN
      dgsr_cmd->SetProperty, PCnorm=event.SELECT
    END
    'DGSR_LAMBDA-RATIO': BEGIN
      dgsr_cmd->SetProperty, LambdaRatio=event.SELECT
    END
    'DGSR_USMON': BEGIN
      ; Upstream Monitor Number (usualy 1)
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, USmonPath=STRCOMPRESS(myValue, /REMOVE_ALL)
    END
    'DGSR_NORMRUN': BEGIN
      ; Norm Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Normalisation=myValue
      
    END
    'DGSR_EMPTYCAN': BEGIN
      ; Empty Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, EmptyCan=myValue
    END
    'DGSR_BLACKCAN': BEGIN
      ; Black Can Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, BlackCan=myValue
    END
    'DGSR_DARK': BEGIN
      ; Dark Current Filename
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Dark=myValue
    END
    'DGSR_TIBCONST': BEGIN
      ; Time Independent Background Constant
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, TIBconst=myValue
    END
    'DGSR_TIB-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, TIBRange_Min=myValue
    END
    'DGSR_TIB-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, TIBRange_Max=myValue
    END
    'DGSR_NORM-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, NormRange_Min=myValue
    END
    'DGSR_NORM-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, NormRange_Max=myValue
    END
    'DGSR_MON-INT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, MonRange_Min=myValue
    END
    'DGSR_MON-INT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, MonRange_Max=myValue
    END
    'DGSR_TOF-CUT-MIN': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Tmin=myValue
    END
    'DGSR_TOF-CUT-MAX': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Tmax=myValue
    END
    'DGSR_DATA-TRANS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DataTrans=myValue
    END
    'DGSR_NORM-TRANS': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, NormTrans=myValue
    END
    'DGSR_DET-EFF': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DetEff=myValue
    END
    'DGSR_PHONON_DOS': BEGIN
      dgsr_cmd->SetProperty, DOS=event.SELECT
      ; Also make the wavelength range fields active (or inactive!)
      DebyeWallerID = WIDGET_INFO(event.top,FIND_BY_UNAME='DGSR_DEBYE_WALLER_FACTOR')
      WIDGET_CONTROL, DebyeWallerID, SENSITIVE=event.SELECT
    END
    'DGSR_DWF': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, DebyeWaller=myValue
    END
    'DGSR_DWF_ERROR': BEGIN
      WIDGET_CONTROL, event.ID, GET_VALUE=myValue
      dgsr_cmd->SetProperty, Error_DebyeWaller=myValue
    END
    ELSE: begin
      ; Do nowt
      print, '*** UVALUE: ' + myUVALUE + ' not handled! ***'
    END
  ENDCASE
  
END