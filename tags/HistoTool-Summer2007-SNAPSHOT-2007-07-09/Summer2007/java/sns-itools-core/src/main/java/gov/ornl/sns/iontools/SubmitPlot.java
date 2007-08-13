package gov.ornl.sns.iontools;

/*
 * this class plot the main plot from the NeXus file in another
 * thread. 
 */
public class SubmitPlot implements Runnable {

	private String cmd = null;
	
	public SubmitPlot(String cmd) {
		this.cmd = cmd;
	}
	
	public void run() {

    ParametersToKeep.bThreadInProcess = true;
    String sMessage = "Run number to plot: " + DataReduction.runNumberValue + "\n";
    LogBookAction.displayMessageInLogBook(sMessage, false);
 		sMessage = "   - Searching for run number " + DataReduction.runNumberValue + "...";
    LogBookAction.displayMessageInLogBook(sMessage, true);
    		
		ProcessingInterfaceWithGui.displayProcessingMessage("Plot in progress");
		IonUtils.executeCmd(this.cmd);

		com.rsi.ion.IONVariable myIONresult;
		myIONresult = IonUtils.queryVariable("result");
		String[] myResultArray;
		myResultArray = myIONresult.getStringArray();
    		
		//Nexus file found or not 
		DataReduction.sNexusFound = myResultArray[0];
		NexusFound foundNexus = new NexusFound(DataReduction.sNexusFound);
		DataReduction.bFoundNexus = foundNexus.isNexusFound();
    				
		//Number of tof 
		DataReduction.sNtof = myResultArray[1];
		Float fNtof = new Float(DataReduction.sNtof);
		ParametersConfiguration.iNtof = fNtof.intValue();
			    		
		//name of tmp output file name
		DataReduction.sTmpOutputFileName = myResultArray[2];
		CheckGUI.checkGUI(DataReduction.bFoundNexus);
    	
		//check if run number is not already part of the data reduction runs
		UpdateDataReductionRunNumberTextField.updateDataReductionRunNumbers(DataReduction.runNumberValue);
  
		//update text field
		if (DataReduction.bFoundNexus) {
			
			sMessage = "found and plotted\n";
      LogBookAction.displayMessageInLogBook(sMessage, true);
      			
			//tell the program that it's not the first run ever
			ParametersToKeep.bFirstRunEver=false;
			if (CheckDataReductionButtonValidation.bAddNexusAndGo) {
				DataReduction.runsAddTextField.setText(CheckDataReductionButtonValidation.sAddNexusAndGoString);
			} else {
    			DataReduction.runsSequenceTextField.setText(CheckDataReductionButtonValidation.sGoSequentiallyString);
    		}	
    	} else {
    		
    		sMessage = "not found\n";
        LogBookAction.displayMessageInLogBook(sMessage, true);
        
    	}
		
		ProcessingInterfaceWithGui.removeProcessingMessage();
    ParametersToKeep.bThreadInProcess = false;
    ThingsToDoWhenThreadIsDone.doWhenMainPlotIsDone();
	}
	
}
