;$Id$

;Makefile that automatically compile the necessary modules
;and create the VM file.

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/utilities/"
.run "system_utilities"

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/RefLSupportGui/"
.run "MakeGuiStep1.pro"
.run "MakeGuiStep2.pro"
.run "MakeGuiStep3.pro"
.run "MakeGuiOutputFile.pro"
.run "MakeGuiSettings.pro"
.run "MakeGuiMainBaseComponents.pro"

cd, "/SNS/users/j35/SVN/HistoTool/trunk/gui/RefLSupport/"
.run "getNumeric.pro"
.run "refl_support_get.pro"
.run "refl_support_put.pro"
.run "refl_support_is.pro"
.run "Main_Base_event.pro"

.run "refl_support_widget.pro"
.run "refl_support_fit.pro"
.run "refl_support_step2.pro"
.run "refl_support_step3.pro"
.run "ArrayDelete.pro"
.run "refl_support_math.pro"
.run "refl_support_file_utility.pro"
.run "refl_support_plot_data.pro"
.run "refl_support_TOF_to_Q.pro"

.run "refl_support_open_file.pro"
.run "refl_support_produce_output.pro"
.run "refl_support_eventcb.pro"
.run "refl_support.pro"
.run "refl_support_eventcb"

resolve_routine, "strsplit",/either
resolve_routine, "loadct",/either
resolve_routine, "errplot",/either
resolve_routine, "read_bmp",/either
resolve_routine, "poly_fit",/either
resolve_routine, "uniq",/either
resolve_routine, "refl_support", /either
resolve_routine, "CW_BGROUP", /either
resolve_routine, "XMANAGER", /either
save,/routines,filename="refl_support.sav"
exit
