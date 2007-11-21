;define path to dependencies and current folder
spawn, 'pwd', CurrentFolder
IdlUtilitiesPath = "../utilities"

cd, IdlUtilitiesPath
.run system_utilities.pro

cd, CurrentFolder + '/RefLSupportGui'
.run "MakeGuiStep1.pro"
.run "MakeGuiStep2.pro"
.run "MakeGuiStep3.pro"
.run "MakeGuiOutputFile.pro"
.run "MakeGuiSettings.pro"
.run "MakeGuiMainBaseComponents.pro"

cd, CurrentFolder
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
