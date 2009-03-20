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
PRO BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  RESOLVE_ROUTINE, 'ref_reduction_eventcb',$
    /COMPILE_FULL_FILE            ; Load event callback routines
    
  ;build the Instrument Selection base
  MakeGuiInstrumentSelection, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  
END



PRO BuildGui, instrument, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  file = OBJ_NEW('idlxmlparser', '.REFreduction.cfg')
  ;==============================================================================
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  APPLICATION = file->getValue(tag=['configuration','application'])+'_low'
  VERSION = file->getValue(tag=['configuration','version'])
  DEBUGGING_VERSION = file->getValue(tag=['configuration','debugging_version'])
  MOUSE_DEBUGGING = file->getValue(tag=['configuration','mouse_debugging'])
  WITH_LAUNCH_SWITCH = file->getValue(tag=['configuration','with_launch_switch'])
  WITH_JOB_MANAGER = file->getValue(tag=['configuration','with_job_manager'])
  CHECKING_PACKAGES = file->getValue(tag=['configuration','checking_packages'])
  DEBUGGING_ON_MAC = file->getValue(tag=['configuration','debugging_on_mac'])
  
  debugging_structure = getDebuggingStructure()
  
  ;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
  ;==============================================================================
  
  LOADCT,5, /SILENT
  
  ;get branch number
  branchArray = STRSPLIT(VERSION,'.',/EXTRACT)
  branch      = STRJOIN(branchArray[0:1],'.')
  
  ;define initial global values - these could be input via external file or
  ;other means
  
  ;get ucams of user if running on linux
  ;and set ucams to 'j35' if running on darwin
  
  IF (!VERSION.os EQ 'darwin') THEN BEGIN
    ucams    = 'j35'
  ENDIF ELSE BEGIN
    ucams    = get_ucams()
  ENDELSE
  
  ;define global variables
  global = ptr_new ({ first_event: 1,$
    substrate_type: PTR_NEW(0L),$
    VERSION: version,$
    debugging_on_mac: DEBUGGING_ON_MAC,$
    
    findcalib: 'findcalib',$
    ts_geom: 'TS_geom_calc.sh',$
    dirpix: 0.0,$
    tmp_geometry_file: '~/.tmp_ref_reduction_geo_file.nxs',$
    dirpix_geometry: '',$
    cvinfo: '',$
    
    in_empty_cell_empty_cell_ptr: PTR_NEW(0L),$
    in_empty_cell_data_ptr: PTR_NEW(0L),$
    
    empty_cell_images: PTR_NEW(0L),$
    sf_equation_file: $
    'REFreduction_images/miniSFequation.png',$
    PrevDNECtabSelect: 0,$
    nexus_tof_path: '/entry/bank1/time_of_flight/',$
    sf_data_tof: PTR_NEW(0L),$
    sf_empty_cell_tof: PTR_NEW(0L),$
    ec_left_click: 0,$
    sf_x0: 0,$
    sf_y0: 0,$
    sf_x1: 0,$
    sf_y1: 0,$
    nexus_proton_charge_path: '/entry/proton_charge/',$
    data_proton_charge: '',$
    empty_cell_proton_charge: '',$
    distance_moderator_sample: $
    '/entry/instrument/moderator/distance/',$
    empty_cell_distance_moderator_sample: '',$
    distance_sample_pixel_path: $
    '/entry/instrument/bank1/distance/',$
    distance_sample_pixel_array: PTR_NEW(0L),$
    SF_RECAP_D_TOTAL_ptr: PTR_NEW(0L),$
    bRecapPlot: 0b,$ ;1 if there is a recap plot
    
    pola_type: '',$ ;'data' or 'norm'
    data_path_flag: '--data-paths',$
    data_path_flag_suffix: '/bank1,1',$
    data_path: '',$ ;for example  '/entry_Off-Off/'
    empty_cell_path: '',$ ;for example  '/entry_Off-Off/'
    norm_path_flag: '--norm-data-paths=/entry-Off_Off/' + $
    'bank1,1',$
    norm_path: '',$
    data_nexus_full_path: '',$
    norm_nexus_full_path: '',$
    empty_cell_nexus_full_path: '',$
    list_pola_state: PTR_NEW(0L),$
    debugging_structure: PTR_NEW(0L),$
    my_package: PTR_NEW(0L),$
    driver_name: 'reflect_reduction',$
    norm_loadct_contrast_changed: 0,$
    data_loadct_contrast_changed: 0,$
    browse_data_path: '~/',$
    main_base: 0L,$
    mouse_debugging: MOUSE_DEBUGGING,$
    debugging_version: DEBUGGING_VERSION,$
    job_manager_cmd:   'java -jar /usr/local/SNS/sbin/sns-job-manager-client-tool/sns-job-manager-client-tool-core-1.3-SNAPSHOT.jar ',$
    with_job_manager:  WITH_JOB_MANAGER,$
    application:       APPLICATION,$
    xml_file_location: '~/',$
    instrument: STRCOMPRESS(instrument,/remove_all),$
    ;name of the current selected REF instrument
    CurrentBatchDataInput: '',$
    CurrentBatchNormInput: '',$
    branch: branch,$
    batch_data_runs : PTR_NEW(0L),$
    nbrIntermediateFiles : 8,$
    batch_process : 'data',$
    batch_norm_runs : PTR_NEW(0L),$
    batch_NormNexus : PTR_NEW(0L),$
    batch_DataNexus : PTR_NEW(0L),$
    batch_percent_error : 0.01,$ ;1% difference acceptebale between angle, s1 and s2
    batch_split2 : '',$
    batch_part2 : '',$
    batch_new_cmd : '',$
    cmd_batch_length : 50,$
    debugger : 1,$ ;give world access to batch
    PrevBatchRowSelected : 0,$
    BatchDefaultPath: '~/results/',$
    BatchDefaultFileFilter : '*_Batch_Run*.txt',$
    BatchFileName : '',$
    DataRunNumber : '',$
    NormRunNumber : '',$
    EmptyCellRunNumber: '',$
    PreviousRunReductionValidated : 0,$
    BatchTable : PTR_NEW(0L),$ ;big array of batch table
    isHDF5format : 1,$
    dr_output_path : '~/results/',$
    archived_data_flag : 1,$
    archived_norm_flag : 1,$
    archived_empty_cell_flag: 1,$
    ;output path define in the REDUCE tab
    cl_output_path : '~/REFreduction_CL/',$
    ;default path where to put the command line output file
    cl_file_ext1    : 'REFreduction_CL_',$
    ;default first part of output command line file
    cl_file_ext2    : '.txt',$
    ;default extension of output command line file
    cl_file_ext3    : '*-04:00.txt',$
    ;default extension of output command line used in dialog_pickfile
    cl_output_name : '',$
    ;name of the file that will contain a copy of the command line
    nexus_bank1_path : '/entry/bank1/data',$ ;nxdir path to bank1 data
    nexus_bank1_path_pola0: '/entry-Off_Off/bank1/data',$
    nexus_bank1_path_pola1: '/entry-Off_On/bank1/data',$
    nexus_bank1_path_pola2: '/entry-On_Off/bank1/data',$
    nexus_bank1_path_pola3: '/entry-On_On/bank1/data',$
    bank1_data : PTR_NEW(0L),$ ;
    bank1_norm : PTR_NEW(0L),$ ;
    bank1_empty_cell: PTR_NEW(0L),$
    miniVersion : 1,$
    ;1 if this is the miniVersion and 0 if it's not
    FilesToPlotList : PTR_NEW(0L),$
    ;list of files to plot (main,rmd and intermediate files)
    PreviewFileNbrLine : 40,$
    ;nbr of line to get from intermediates files
    DataReductionStatus : 'ERROR',$
    ; status of the data reduction 'OK' or 'ERROR'
    PlotsTitle : PTR_NEW(0L),$
    ;title of all the plots (main and intermediate)
    MainPlotTitle : '',$
    ;title of main data reduction
    IntermPlots : INTARR(9),$
    ;0 for inter. plot no desired, 1 for desired
    CurrentPlotsFullFileName:PTR_NEW(0L),$
    ;full path name of the plot currently plotted
    OutputFileName : '',$
    ; ex: REF_L_2000_2007-08-31T09:28:59-04:00.txt
    IsoTimeStamp : '',$
    ; ex: 2007-08-31T09:28:59-04:00
    ExtOfAllPlots : PTR_NEW(0L),$
    ;extension of all the files created
    PrevTabSelect : 0,$
    ;name of previous main tab selected
    PrevDataTabSelect: 0,$
    ;index of previous data tab selected
    PrevNormTabSelect: 0,$
    ;index of previous normalization tab selected
    PrevDataZoomTabSelect: 0,$
    ;name of previous zoom/NXsummary tab selected (data)
    PrevNormZoomTabSelect: 0,$
    ;name of previous zoom/NXsummary tab selected (normalization)
    DataNeXusFound : 0, $
    ;no data nexus found by default
    NormNeXusFound : 0, $
    ;no norm nexus found by default
    EmptyCellNexusFound: 0,$
    ;no empty cell nexus found by default
    data_full_nexus_name : '',$
    ;full path to data nexus file
    norm_full_nexus_name : '',$
    ;full path to norm nexus file
    empty_cell_full_nexus_name : '',$
    ;full path to empty cell nexus file
    xsize_1d_draw : 2*304L,$
    ;size of 1D draw (should be Ntof)
    REF_L : 'REF_L',$
    ;name of REF_L instrument
    REF_M : 'REF_M',$
    ;name of REF_M instrument
    Nx_REF_L : 256L,$
    ;Nx for REF_L instrument
    Ny_REF_L : 304L,$
    ;Ny for REF_L instrument
    Nx_REF_M : 304L,$
    ;Nx for REF_M instrument
    Ny_REF_M : 256L,$
    ;Ny for REF_M instrument
    Ntof_DATA : 0L, $
    ;TOF for data file
    Ntof_empty_cell : 0L, $
    ;TOF for empty cell file
    Ntof_NORM : 0L, $
    ;TOF for norm file
    failed : 'FAILED',$
    ;failed message to display
    processing_message : '(PROCESSING)',$
    ;processing message to display
    processing: '(PROCESSING)',$
    ok: 'OK',$
    data_tmp_dat_file : 'tmp_data.dat',$
    ;default name of tmp binary data file
    full_data_tmp_dat_file : '',$
    ;full path of tmp .dat file for data
    norm_tmp_dat_file : 'tmp_norm.dat',$
    ;default name of tmp binary norm file
    full_norm_tmp_dat_file : '',$
    ;full path of tmp .dat file for normalization
    working_path : '~/results/',$
    ;where the tmp file will be created
    ucams : ucams, $
    ;ucams of the current user
    data_run_number: 0L,$
    ;run number of the data file loaded and plotted
    norm_run_number: 0L,$
    ;run number of the norm. file loaded and plotted
    DATA_DD_ptr : PTR_NEW(0L),$
    ;detector view of DATA (2D)
    DATA_D_ptr : PTR_NEW(0L),$
    ;(ntot,Ny,Nx) array of DATA
    empty_cell_DD_ptr: PTR_NEW(0L),$
    ;detector view of empty cell (2D)
    DATA_D_Total_ptr : PTR_NEW(0L),$
    ;img=total(img,x) x=2 for REF_M and x=3 for REF_L
    NORM_D_Total_ptr : PTR_NEW(0L),$
    ;img=total(img,x) x=2 for REF_M and x=3 for REF_L
    empty_cell_D_ptr: PTR_NEW(0L),$
    ;(ntot,Ny,Nx) array of empty_cell
    empty_cell_D_Total_ptr: PTR_NEW(0L),$
    ;img=total(img,x) x=2 for REF_M and x=3 for REF_L
    NORM_DD_ptr : PTR_NEW(0L),$
    ;detector view of NORMALIZATION (2D)
    NORM_D_ptr : PTR_NEW(0L),$
    ;(Ntof,Ny,Nx) array of NORMALIZATION
    tvimg_data_ptr : PTR_NEW(0L),$
    ;rebin data img
    tvimg_empty_cell_ptr: PTR_NEW(0L),$
    ;rebin empty cell img
    tvimg_norm_ptr : PTR_NEW(0L),$
    ;rebin norm img
    roi_selection_color: 250L,$
    ;color of roi selection
    back_selection_color : 50L,$
    ;color of background selection
    peak_selection_color : 100L,$
    ;color of peak exclusion
    data_roi_selection : PTR_NEW(0L),$
    ;Ymin and Ymax for data roi
    norm_roi_selection : PTR_NEW(0L),$
    ;Ymin and Ymax for norm roi
    data_back_selection : PTR_NEW(0L),$
    ;Ymin and Ymax for data background
    norm_back_selection : PTR_NEW(0L),$
    ;Ymin and Ymax for norm background
    data_peak_selection : PTR_NEW(0L),$
    ;Ymin and Ymax for data peak
    norm_peak_selection : PTR_NEW(0L),$
    ;Ymin and Ymax for norm peak
    data_roi_ext : '_data_roi.dat',$
    ;extension file name of data roi
    data_back_ext: '_data_back.dat',$
    ;extension file name of data back
    norm_roi_ext : '_norm_roi.dat',$
    ;extension file name of norm roi
    norm_back_ext: '_norm_back.dat',$
    ;extension file name of norm back
    load_roi_ext : '_roi.dat',$
    ;filter used to load ROI files for data and norm
    load_back_ext : '_back.dat',$
    ;filter used to load background files for data and norm
    roi_file_preview_nbr_line : 20L,$
    ;nbr of line to display in preview
    select_data_status : 0,$
    ;Status of the data selection (see below)
    select_norm_status : 0,$
    ;Status of the norm selection (see below)
    select_zoom_status : 0,$
    ;Status of the zoom (0=no zoom; 1=zoom)
    select_norm_zoom_status: 0,$
    ;Status of the normalization zoom (0=no zoom; 1=zoom)
    flt0_ptr : PTRARR(8,/allocate_heap),$
    ;arrays of all the x-axis
    flt1_ptr : PTRARR(8,/allocate_heap),$
    ;arrays of all the y-axis
    flt2_ptr : PTRARR(8,/allocate_heap),$
    ;arrays of all the y-error data
    fltPreview_ptr: PTR_NEW(0L),$
    ;metadata of main data reduction file
    fltPreview_xml_ptr: PTR_NEW(0L),$
    ;metadata of xml file
    InstrumentGeometryPath : '',$
    ;default path where to get the instrument geometry to overwrite
    InstrumentDataGeometryFileName : '',$
    ;full path to instrument geometry to overwrite
    InstrumentNormGeometryFileName : '',$
    ;full path to instrument geometry to overwrite
    DataZoomFactor: 2L,$
    ;scale factor for zoom of 1D Data
    NormalizationZoomFactor: 2L,$
    ;scale factor for zoom of 1D Normalization
    DataX : 0L,$
    ;last x position of cursor in data 1d drawfor zoom
    DataY : 0L,$
    ;last y position of cursor in data 1d drawfor zoom
    NormX : 0L,$
    ;last x position of cursor in norm. 1d draw for zoom
    NormY : 0L,$
    ;last x position of cursor in norm 1d draw for zoom
    LogBookPath : '/SNS/users/LogBook/',$
    ;path where to put the log book
    MacNexusFile : '~/SNS/REF_L/IPTS-231/1/4146/NeXus/REF_L_4146.nxs',$
    ;full path to NeXus file on the mac
    MacNXsummary : '~/local/nxsummary_4146.txt',$
    ;full path to NXsummary file that will be read on Mac (instead of
    ;using NXsummary)
    PreviousDataNexusListSelected: 0,$
    ;previous element selected in data nexus droplist
    PreviousECNexusListSelected: 0,$
    ;previous element selected in empty cell nexus droplist
    PreviousNormNexusListSelected: 0,$
    ;previous element selected in normalization nexus droplist
    InitialDataContrastDropList: 5,$
    ;initial value of the contrast data droplist
    PreviousDataContrastDroplistIndex: 5,$
    ;previous value of data contrast droplist
    PreviousDataContrastBottomSliderIndex : 0,$
    ;previous value of data contrast bottom color slider
    PreviousDataContrastNumberSliderIndex : 255,$
    ;previous value of data contrast number of color slider
    InitialNormContrastDropList: 5,$
    ;initial value of the contrast norm droplist
    PreviousNormContrastDroplistIndex: 5,$
    ;previous value of norm contrast droplist
    PreviousNormContrastBottomSliderIndex : 0,$
    ;previous value of norm contrast bottom color slider
    PreviousNormContrastNumberSliderIndex : 255,$
    ;previous value of norm contrast number of color slider
    DataXYZminmaxArray : PTR_NEW(0L),$
    ;xmin, xmax, ymin, ymax, zmin, zmax of data (loaded in
    ;Plot1DDdataFile.pro
    NormXYZminmaxArray : PTR_NEW(0L),$
    ;xmin, xmax, ymin, ymax, zmin, zmax of data (loaded in
    ;Plot1DDNormalizationFile.pro
    PrevData1D3DAx : 30L,$
    ;previous Ax value of Data 1D_3D plot
    PrevData1D3DAz : 30L,$
    ;previsou Az value of data 1D_3D plot
    PrevData2D3DAx : 30L,$
    ;previous Ax value of Data 2D_3D plot
    PrevData2D3DAz : 30L,$
    ;previsou Az value of data 2D_3D plot
    DefaultData1D3DAx : 30L, $
    ;default Ax vlaue of data 1D_3D plot
    DefaultData1D3DAz : 30L, $
    ;default Az value of data 1D_3D plot
    DefaultData2D3DAx : 30L, $
    ;default Ax vlaue of data 2D_3D plot
    DefaultData2D3DAz : 30L, $
    ;default Az value of data 2D_3D plot
    PrevNorm1D3DAx : 30L,$
    ;previous Ax value of norm 1D_3D plot
    PrevNorm1D3DAz : 30L,$
    ;previsou Az value of norm 1D_3D plot
    PrevNorm2D3DAx : 30L,$
    ;previous Ax value of NORM 2D_3D plot
    PrevNorm2D3DAz : 30L,$
    ;previsou Az value of NORM 2D_3D plot
    DefaultNorm1D3DAx : 30L, $
    ;default Ax vlaue of norm 1D_3D plot
    DefaultNorm1D3DAz : 30L, $
    ;default Az value of norm 1D_3D plot
    DefaultNorm2D3DAx : 30L, $
    ;default Ax vlaue of norm 2D_3D plot
    DefaultNorm2D3DAz : 30L, $
    ;default Az value of norm 2D_3D plot
    InitialData1d3dContrastDropList : 5,$
    ;default value of the data loadct 1d_3d plot
    InitialData2d3dContrastDropList : 5,$
    ;default value of the data loadct 2d_3d plot
    PrevData1d3dContrastDropList : 5,$
    ;previous value of the data loadct 1d_3d plot
    PrevData2d3dContrastDropList : 5,$
    ;previous value of the data loadct 2d_3d plot
    InitialNorm1d3dContrastDropList : 5,$
    ;default value of the norm loadct 1d_3d plot
    InitialNorm2d3dContrastDropList : 5,$
    ;default value of the norm loadct 2d_3d plot
    PrevNorm1d3dContrastDropList : 5,$
    ;previous value of the norm loadct 1d_3d plot
    PrevNorm2d3dContrastDropList : 5,$
    ;previous value of the norm loadct 2d_3d plot
    Data_1d_3d_min_max : PTR_NEW(0L),$
    ;[min,max] values of the data img array (used to reset z in 1d_3d)
    Data_2d_3d_min_max : PTR_NEW(0L),$
    ;[min,max] values of the data img array (used to reset z in 2d_3d)
    Normalization_1d_3d_min_max : PTR_NEW(0L),$
    ;[min,max] values of the normalization img array (used to reset z in 1d_3d)
    Normalization_2d_3d_min_max : PTR_NEW(0L),$
    ;[min,max] values of the normalization img array (used to reset z in
    ;2d_3d)
    DataXMouseSelection : 0L,$
    ;Previous x position of data left click
    NormXMouseSelection : 0L,$
    ;Previous x position of normalization left click
    UpDownMessage : '',$
    ;Message to display when left click main plot
    REFreductionVersion : ''$
    ;Version of REFreduction Tool
    })
    
  (*(*global).empty_cell_images) = getEmptyCellImages()
  (*(*global).substrate_type)    = getSubstrateType()
  
  (*(*global).debugging_structure) = debugging_structure
  BatchTable = STRARR(10,20)
  (*(*global).BatchTable) = BatchTable
  
  ;------------------------------------------------------------------------
  ;explanation of the select_data_status and select_norm_status
  ;0 nothing has been done yet
  ;1 user left click first and is now in back selection 1st border
  ;2 user release click and is done with back selection 1st border
  ;3 user right click and is now entering the back selection of 2nd border
  ;4 user left click and is now selecting the 2nd border
  ;5 user release click and is done with selection of 2nd border
  ;-----------------------------------------------------------------------------
  
  full_data_tmp_dat_file = (*global).working_path + (*global).data_tmp_dat_file
  (*global).full_data_tmp_dat_file = full_data_tmp_dat_file
  full_norm_tmp_dat_file = (*global).working_path + (*global).norm_tmp_dat_file
  (*global).full_norm_tmp_dat_file = full_norm_tmp_dat_file
  (*(*global).data_back_selection) = [-1,-1]
  (*(*global).data_peak_selection) = [-1,-1]
  (*(*global).norm_back_selection) = [-1,-1]
  (*(*global).norm_peak_selection) = [-1,-1]
  (*(*global).data_roi_selection)  = [-1,-1]
  (*(*global).norm_roi_selection)  = [-1,-1]
  
  (*global).UpDownMessage = 'Use U(up) or D(down) to move selection ' + $
    'vertically pixel per pixel.'
  (*global).REFreductionVersion = VERSION
  
  PlotsTitle = ['Data Combined Specular TOF Plot',$
    'Data Combined Background TOF Plot',$
    'Data Combined Subtracted TOF Plot',$
    'Norm. Combined Specular TOF Plot',$
    'Norm. Combined Background TOF Plot',$
    'Norm. Combined Subtracted TOF Plot',$
    'R vs TOF Plot',$
    'R vs TOF Combined Plot',$
    ;              'XML output file',$
    'Empty Cell R vs TOF Plot']
  (*(*global).PlotsTitle) = PlotsTitle
  MainPlotTitle = 'Main Data Reduction Plot'
  (*global).MainPlotTitle = MainPlotTitle
  
  ;instrument geometry
  if (instrument EQ 'REF_L') then begin ;REF_L
    InstrumentGeometryPath = '/SNS/REF_L/2006_1_4B_CAL/calibrations/'
  endif else begin
    InstrumentGeometryPath = '/SNS/REF_M/2006_1_4A_CAL/calibrations/'
  endelse
  (*global).InstrumentGeometryPath = InstrumentGeometryPath
  
  ExtOfAllPlots = ['.txt',$
    '.rmd',$
    '_data.sdc',$
    '_data.bkg',$
    '_data.sub',$
    '_norm.sdc',$
    '_norm.bkg',$
    '_norm.sub',$
    '.rtof',$
    '.crtof']
  (*(*global).ExtOfAllPlots) = ExtOfAllPlots
  
  ;define Main Base variables
  ;[xoffset, yoffset, scr_xsize, scr_ysize]
  
  ;MainBaseSize  = [50,50,905,685]
  MainBaseSize  = [50,50,905,685]
  
  MainBaseTitle = 'miniReflectometer Data Reduction Package - '
  MainBaseTitle += VERSION
  IF (DEBUGGING_VERSION EQ 'yes') THEN BEGIN
    MainBaseTitle += ' (DEBUGGING VERSION)'
  ENDIF
  
  ;Build Main Base
  MAIN_BASE = WIDGET_BASE(GROUP_LEADER  = wGroup,$
    UNAME         = 'MAIN_BASE',$
    XOFFSET       = MainBaseSize[0],$
    YOFFSET       = MainBaseSize[1],$
    TITLE         = MainBaseTitle,$
    SPACE         = 0,$
    XPAD          = 0,$
    MBAR          = WID_BASE_0_MBAR,$
    X_SCROLL_SIZE = MainBaseSize[2],$
    Y_SCROLL_SIZE = 600,$
    /SCROLL)
    
  ;attach global structure with widget ID of widget main base widget ID
  WIDGET_CONTROL, MAIN_BASE, SET_UVALUE=global
  
  ;polarization state base ======================================================
  pola_base = WIDGET_BASE(MAIN_BASE,$
    XOFFSET   = 70,$
    YOFFSET   = 150,$
    SCR_XSIZE = 200,$
    SCR_YSIZE = 190,$
    UNAME     = 'polarization_state',$
    FRAME     = 10,$
    MAP       = 0,$
    /COLUMN,$
    /BASE_ALIGN_CENTER)
    
  (*global).main_base = MAIN_BASE
  
  label = WIDGET_LABEL(pola_base,$
    VALUE = 'Select a Polarization State:')
  label = WIDGET_LABEL(pola_base,$
    VALUE = '                                             ',$
    UNAME = 'pola_file_name_uname')
    
  button_base = WIDGET_BASE(pola_base,$
    /COLUMN,$
    /EXCLUSIVE)
    
  button1 = WIDGET_BUTTON(button_base,$
    VALUE = 'Off_Off',$
    UNAME = 'pola_state1_uname',$
    SENSITIVE = 1)
    
  button2 = WIDGET_BUTTON(button_base,$
    VALUE = 'Off_On',$
    UNAME = 'pola_state2_uname',$
    SENSITIVE = 1)
    
  button3 = WIDGET_BUTTON(button_base,$
    VALUE = 'On_Off',$
    UNAME = 'pola_state3_uname',$
    SENSITIVE = 0)
    
  button4 = WIDGET_BUTTON(button_base,$
    VALUE = 'On_On',$
    UNAME = 'pola_state4_uname',$
    SENSITIVE = 0)
    
  WIDGET_CONTROL, button1, /SET_BUTTON
  
  ok_cancel_base = WIDGET_BASE(pola_base,$ ;....................................
    /ROW)
    
  cancel_button = WIDGET_BUTTON(ok_cancel_base,$
    VALUE = 'CANCEL',$
    UNAME = 'cancel_pola_state',$
    XSIZE = 90)
    
  OK_button = WIDGET_BUTTON(ok_cancel_base,$
    VALUE = 'VALIDATE',$
    UNAME = 'ok_pola_state',$
    XSIZE = 90)
    
  ;------------------------------------------------------------------------------
    
  ;HELP MENU in Menu Bar
  HELP_MENU = WIDGET_BUTTON(WID_BASE_0_MBAR,$
    UNAME = 'help_menu',$
    VALUE = 'HELP',$
    /MENU)
    
  HELP_BUTTON = WIDGET_BUTTON(HELP_MENU,$
    VALUE = 'HELP',$
    UNAME = 'help_button')
    
  IF (ucams EQ 'j35') THEN BEGIN
    my_help_button = WIDGET_BUTTON(HELP_MENU,$
      VALUE = 'MY HELP',$
      UNAME = 'my_help_button')
  ENDIF
  
  ;add version to program
  if ((*global).miniVersion) then begin
    xoff = 715
  endif else begin
    xoff = 1030
  endelse
  
  structure = {with_launch_button: WITH_LAUNCH_SWITCH}
  
  ;Build main GUI
  miniMakeGuiMainTab, $
    MAIN_BASE, $
    MainBaseSize, $
    instrument, $
    PlotsTitle,$
    structure
    
  WIDGET_CONTROL, /REALIZE, MAIN_BASE
  XMANAGER, 'MAIN_BASE', MAIN_BASE, /NO_BLOCK
  
  ; initialize contrast droplist
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_contrast_droplist')
  WIDGET_CONTROL, id, set_droplist_select=(*global).InitialDataContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_contrast_droplist')
  WIDGET_CONTROL, id, set_droplist_select=(*global).InitialNormContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_loadct_1d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialData1d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_loadct_1d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNorm1d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='data_loadct_2d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialData2d3DContrastDropList
  id = WIDGET_INFO(Main_base,Find_by_Uname='normalization_loadct_2d_3d_droplist')
  WIDGET_CONTROL, id, set_droplist_select= $
    (*global).InitialNorm2d3DContrastDropList
    
  ;initialize CommandLineOutput widgets (path and file name)
  id = WIDGET_INFO(Main_base, find_by_uname='cl_directory_text')
  WIDGET_CONTROL, id, set_value=(*global).cl_output_path
  time = RefReduction_GenerateIsoTimeStamp()
  file_name = (*global).cl_file_ext1 + time + (*global).cl_file_ext2
  id = WIDGET_INFO(Main_Base, find_by_uname='cl_file_text')
  WIDGET_CONTROL, id, set_value=file_name
  
  ;------------------------------------------------------------------------------
  
  IF (ucams EQ 'j35' OR $
    ucams EQ '2zr') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='reduce_cmd_line_preview')
    WIDGET_CONTROL, id, /editable
    WIDGET_CONTROL, /CONTEXT_EVENTS
  ENDIF
  
  IF (ucams EQ 'j35') THEN BEGIN
    id = WIDGET_INFO(MAIN_BASE,find_by_uname='cmd_status_preview')
    WIDGET_CONTROL, id, /editable
  ENDIF
  
  IF (DEBUGGING_VERSION EQ 'yes') THEN BEGIN
  
  ; Default Main Tab Shown
  ;    id1 = WIDGET_INFO(MAIN_BASE, FIND_BY_UNAME='main_tab')
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 1 ;REDUCE
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 2 ;PLOT
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 3 ;BATCH
  ;    WIDGET_CONTROL, id1, SET_TAB_CURRENT = 4 ;LOG BOOK
  
  ;default path of Load Batch files
  ;    (*global).BatchDefaultPath = '/SNS/REF_L/shared/'
  
  ; default tabs shown
  ;   id1 = widget_info(MAIN_BASE, find_by_uname='roi_peak_background_tab')
  ;   widget_control, id1, set_tab_current = 1 ;peak/background
  
  ;   id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
  ;   widget_control, id2, set_tab_current = 0 ;DATA
  
  ;id2 = widget_info(MAIN_BASE, find_by_uname='data_normalization_tab')
  ;widget_control, id2, set_tab_current = 2 ;empty_cell
  
  ; id3 = widget_info(MAIN_BASE, find_by_uname='load_normalization_d_dd_tab')
  ; widget_control, id3, set_tab_current = 3 ;Y vs X (3D)
  
  ;  to get the manual mode
  ; id6 = widget_info(MAIN_BASE, find_by_uname=
  ; 'normalization2d_rescale_tab1_base')
  ; widget_control, id6, map=0
  
  ; id5 = widget_info(MAIN_BASE, find_by_uname=
  ; 'normalization2d_rescale_tab2_base')
  ; widget_control, id5, map=1
  
  ;id4 = widget_info(MAIN_BASE, find_by_uname='data_back_peak_rescale_tab')
  ;widget_control, id4, set_tab_current = 2 ;SCALE/RANGE
  
  ;BatchTable [*,0] = ['YES', $
  ;                    '5225,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; BatchTable[*,1] = ['NO', $
  ;                    '7545,5225,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; BatchTable[*,2] = ['NO', $
  ;                    '6000,7000,5225,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; BatchTable[*,3] = ['> YES <', $
  ;                    '5225,10000,5454', $
  ;                    '3443', $
  ;                    '0.345', $
  ;                    '0.15', $
  ;                    '0.15', $
  ;                    '2008y_02m_19d_01h_15mn', $
  ;                    'reflect_reduction 5225 5454 --norm=3443']
  ; (*(*global).BatchTable) = BatchTable
  
  ; id = widget_info(Main_base,find_by_uname='batch_table_widget')
  ; widget_control, id, set_value=BatchTable
  
  ; id = widget_info(Main_base,find_by_uname='save_as_file_name')
  ; widget_control, id, set_value='REF_L_Batch_Run4000_2008y_02m_26d.txt'
  
  ENDIF ;end of debugging_version statement
  
  ;display empty cell images ----------------------------------------------------
  ;get images files
  sImages = (*(*global).empty_cell_images)
  
  ;background image
  draw1 = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='confuse_background')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.confuse_background)
  TV, image, 0,0,/true
  
  ;empty cell image
  empty_cell_draw = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='empty_cell_draw')
  WIDGET_CONTROL, empty_cell_draw, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.empty_cell)
  TV, image, 0,0,/true
  
  ;data background image
  data_background_draw = WIDGET_INFO(MAIN_BASE, $
    FIND_BY_UNAME='data_background_draw')
  WIDGET_CONTROL, data_background_draw, GET_VALUE=id
  WSET, id
  image = READ_PNG(sImages.data_background)
  TV, image, 0,0,/true
  
  ;display equation of Scalling factor in Empty Cell tab
  draw1 = WIDGET_INFO(MAIN_BASE,FIND_BY_UNAME='scaling_factor_equation_draw')
  WIDGET_CONTROL, draw1, GET_VALUE=id
  WSET, id
  image = READ_PNG((*global).sf_equation_file)
  TV, image, 0,0,/true
  
  ;==============================================================================
  ;checking packages
  IF (DEBUGGING_VERSION EQ 'yes') THEN BEGIN
    packages_required, global, my_package
    (*(*global).my_package) = my_package
  ENDIF
  IF (CHECKING_PACKAGES EQ 'yes') THEN BEGIN
    packages_required, global, my_package
    checking_packages_routine, MAIN_BASE, my_package, global
    update_gui_according_to_package, MAIN_BASE, my_package
  ENDIF
  
  ;==============================================================================
  ;populate the list of proposal droplist (data, normalization,empty_cell)
  populate_list_of_proposal, MAIN_BASE, (*global).instrument
  
  ;==============================================================================
  ;logger message
  logger_message  = '/usr/bin/logger -p local5.notice IDLtools '
  logger_message += APPLICATION + '_' + VERSION + ' ' + ucams
  logger_message += ' ' + getYear()
  error = 0
  CATCH, error
  IF (error NE 0) THEN BEGIN
    CATCH,/CANCEL
  ENDIF ELSE BEGIN
    SPAWN, logger_message
  ENDELSE
END

;------------------------------------------------------------------------------
;Empty stub procedure used for autoloading.
PRO mini_ref_reduction, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ;check instrument here
  SPAWN, 'hostname',LISTENING
  CASE (listening) OF
    'lrac': instrument = 'REF_L'
    'mrac': instrument = 'REF_M'
    'heater': instrument = 'UNDEFINED'
    else: instrument = 'UNDEFINED'
  ENDCASE
  
  IF (instrument EQ 'UNDEFINED') THEN BEGIN
    BuildInstrumentGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ENDIF ELSE BEGIN
    BuildGui, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_, instrument
  ENDELSE
END





