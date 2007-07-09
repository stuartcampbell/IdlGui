package gov.ornl.sns.iontools;

public class GuiLiveParameters {

	private String  sInstrument;
	private String  sSignalPidFile;
    private String  sBackPidFile;
	private String  sRunNumber;
	private boolean bSignalPidFileSaved;
    private boolean bBackPidFileSaved;
    private String  sWavelengthMin;
    private String  sWavelengthMax;
    private String  sWavelengthWidth;
    private String  sDetectorAngle;
    private String  sDetectorAnglePM;
    private boolean bDetectorAngleRadians;
    private boolean bNormalizationSwitch;   
    private String  sNormalizationRunNumber;
    private boolean bBackgroundSwitch;
    private boolean bNormalizationBackgroundSwitch;
    private boolean bIntermediatePlotsSwitch;
    private boolean bExtraPlotsSR;
	private boolean bExtraPlotsBS;
	private boolean bExtraPlotsSRB;
	private boolean bExtraPlotsNR;
	private boolean bExtraPlotsBRN;
	private boolean bCombineDataSpectrum;
    private boolean bOverwriteInstrumentGeometry;
    private String  sInstrumentGeometry;
    private boolean bAddNexusAndGo;           
    private String  sAddNexusAndGoString;
    private String  sGoSequentiallyString;
	
	GuiLiveParameters() {
		
		sInstrument = DataReduction.instrument;   	
		
		sSignalPidFile = DataReduction.signalPidFileTextField.getText();
		
		sBackPidFile = DataReduction.backgroundPidFileTextField.getText();
		
		sRunNumber = DataReduction.runNumberTextField.getText();
    	
		if (sSignalPidFile.compareTo("") == 0) {
    		bSignalPidFileSaved = true;
    	} else {
    		bSignalPidFileSaved = false;
    	}
		
		if (sBackPidFile.compareTo("") == 0) {
			bBackPidFileSaved = true;
		} else {
			bBackPidFileSaved = false;
		}
		
		sWavelengthMin = DataReduction.wavelengthMinTextField.getText();
		sWavelengthMax = DataReduction.wavelengthMaxTextField.getText();
		sWavelengthWidth = DataReduction.wavelengthWidthTextField.getText();
		
		if (DataReduction.detectorAngleUnuitsComboBox.getSelectedIndex() == 0) {
			bDetectorAngleRadians = true;
		} else {
			bDetectorAngleRadians = false;
		}
		
		sDetectorAngle = DataReduction.detectorAngleTextField.getText();
		sDetectorAnglePM = DataReduction.detectorAnglePMTextField.getText();
		if (!bDetectorAngleRadians) { //degres
			sDetectorAngle = UtilsFunction.convertDegresToRadians(sDetectorAngle);
			sDetectorAnglePM = UtilsFunction.convertDegresToRadians(sDetectorAnglePM);
		}
		
		if (DataReduction.yesNormalizationRadioButton.isSelected()) {
			bNormalizationSwitch = true;
		} else {
			bNormalizationSwitch = false;
		}
		
		sNormalizationRunNumber = DataReduction.normalizationTextField.getText(); 	    	
    	
		if (DataReduction.yesBackgroundRadioButton.isSelected()) {
    		bBackgroundSwitch = true;
    	} else {
    		bBackgroundSwitch = false;
    	}
    	
		if (DataReduction.yesNormBackgroundRadioButton.isSelected()) {
    		bNormalizationBackgroundSwitch = true;
    	} else {
    		bNormalizationBackgroundSwitch = false;
    	}
    	
		if (DataReduction.yesIntermediateRadioButton.isSelected()) {
    		bIntermediatePlotsSwitch = true;
    	} else {
    		bIntermediatePlotsSwitch = false;
    	}
    	
		if (DataReduction.extraPlotsSRCheckBox.isSelected() && 
			DataReduction.extraPlotsSRCheckBox.isEnabled()) {
    		bExtraPlotsSR = true;
    	} else {
    		bExtraPlotsSR = false;
    	}
    	
    	if (DataReduction.extraPlotsBSCheckBox.isSelected() &&
    		DataReduction.extraPlotsBSCheckBox.isEnabled()) {
    		bExtraPlotsBS = true;
    	} else {
    		bExtraPlotsBS = false;
    	}
    	
    	if (DataReduction.extraPlotsSRBCheckBox.isSelected() &&
    		DataReduction.extraPlotsSRBCheckBox.isEnabled()) {
    		bExtraPlotsSRB = true;
    	} else {
    		bExtraPlotsSRB = false;
    	}
    	
    	if (DataReduction.extraPlotsNRCheckBox.isSelected() &&
    		DataReduction.extraPlotsNRCheckBox.isEnabled()) {
    		bExtraPlotsNR = true;
    	} else {
    		bExtraPlotsNR = false;
    	}
    	
    	if (DataReduction.extraPlotsBRNCheckBox.isSelected() &&
    		DataReduction.extraPlotsBRNCheckBox.isEnabled()) {
    		bExtraPlotsBRN = true;
    	} else {
    		bExtraPlotsBRN = false;
    	}
    	
    	if (DataReduction.yesCombineSpectrumRadioButton.isSelected()) {
    		bCombineDataSpectrum = true;
    	} else {
    		bCombineDataSpectrum = false;
    	}
    	
    	if (DataReduction.yesInstrumentGeometryRadioButton.isSelected()) {
    		bOverwriteInstrumentGeometry = true;
    	} else {
    		bOverwriteInstrumentGeometry = false;
    	}
    	
    	sInstrumentGeometry = DataReduction.instrumentGeometryTextField.getText();
    	
    	if (DataReduction.runsTabbedPane.getSelectedIndex() == 0) {
    		bAddNexusAndGo = true;
    	} else {
    		bAddNexusAndGo = false;
    	}
    	
    	sAddNexusAndGoString = DataReduction.runsAddTextField.getText();     
    	
    	sGoSequentiallyString = DataReduction.runsSequenceTextField.getText();    	
    
    	//outputData();
	}
	
	public String getInstrument() {
		return sInstrument;
	}
	
	public String getSignalPidFile() {
		return sSignalPidFile;
	}
	
	public String getBackPidFile() {
		return sBackPidFile;
	}
	
	public String getRunNumber() {
		return sRunNumber;
	}
	
	public boolean isSignalPidFileSaved() {
		return bSignalPidFileSaved;
	}
	
	public boolean isBackPidFileSaved() {
		return bBackPidFileSaved;
	}
	
	public String getWavelengthMin() {
		return sWavelengthMin;
	}
	
	public String getWavelengthMax() {
		return sWavelengthMax;
	}
	
	public String getWavelengthWidth() {
		return sWavelengthWidth;
	}
	
	public String getDetectorAngle() {
		return sDetectorAngle;
	}
	
	public String getDetectorAnglePM() {
		return sDetectorAnglePM;
	}
	
	public boolean isDetectorAngleRadians() {
		return bDetectorAngleRadians;
	}
	
	public boolean isNormalizationSwitch() {
		return bNormalizationSwitch;
	}
	
	public String getNormalizationRunNumber() {
		return sNormalizationRunNumber;
	}
	
	public boolean isBackgroundSwitch() {
		return bBackgroundSwitch;
	}
	
	public boolean isNormalizationBackgroundSwitch() {
		return 	bNormalizationBackgroundSwitch;
	}
	
	public boolean isIntermediatePlotsSwitch() {
		return bIntermediatePlotsSwitch;
	}
	
	public boolean isExtraPlotsSRselected() {
		return bExtraPlotsSR;
	}
	
	public boolean isExtraPlotsBSselected() {
		return bExtraPlotsBS;
	}
	
	public boolean isExtraPlotsSRBselected() {
		return bExtraPlotsSRB;
	}
	
	public boolean isExtraPlotsNRselected() {
		return bExtraPlotsNR;
	}
	
	public boolean isExtraPlotsBRNselected() {
		return bExtraPlotsBRN;
	}
	
	public boolean isCombineDataSpectrum() {
		return bCombineDataSpectrum;
	}
	
	public boolean isOverwriteInstrumentGeometry() {
		return bOverwriteInstrumentGeometry;
	}

	public String getInstrumentGeometry() {
		return sInstrumentGeometry;
	}
	
	public boolean isAddNexusAndGo() {
		return bAddNexusAndGo;
	}
	
	public String getAddNexusAndGoString() {
		return sAddNexusAndGoString;
	}
	
	public String getGoSequentiallyString() {
		return sGoSequentiallyString;
	}
		
	private void outputData() {
	
		System.out.println("****** GuiLiveParameters *******");
		System.out.println("sInstrument: " + sInstrument);
		System.out.println("sSignalPidFile: " + sSignalPidFile);
		System.out.println("sBackPidFile: " + sBackPidFile);
		System.out.println("sRunNumber: " + sRunNumber);
		System.out.println("bSignalPidFileSaved: " + bSignalPidFileSaved);
		System.out.println("bBackPidFileSaved: " + bBackPidFileSaved);
		System.out.println("sWavelengthMin: " + sWavelengthMin);
		System.out.println("sWavelengthMax: " + sWavelengthMax);
		System.out.println("sWavelengthWidth: " + sWavelengthWidth);
		System.out.println("sDetectorAngle: " + sDetectorAngle);
		System.out.println("sDetectorAnglePM: " + sDetectorAnglePM);
		System.out.println("bDetectorAngleRadians: " + bDetectorAngleRadians);
		System.out.println("bNormalizationSwitch: " + bNormalizationSwitch);
		System.out.println("sNormalizationRunNumber: " + sNormalizationRunNumber);
		System.out.println("bBackgroundSwitch: " + bBackgroundSwitch);
		System.out.println("bNormalizationBackgroundSwitch: " + bNormalizationBackgroundSwitch);
		System.out.println("bIntermediatePlotsSwitch: " + bIntermediatePlotsSwitch);
		System.out.println("bExtraPlotsSR: " + bExtraPlotsSR);
		System.out.println("bExtraPlotsBS: " + bExtraPlotsBS);
		System.out.println("bExtraPlotsSRB: " + bExtraPlotsSRB);
		System.out.println("bExtraPlotsNR: " + bExtraPlotsNR);
		System.out.println("bExtraPlotsBRN: " + bExtraPlotsBRN);
		System.out.println("bCombineDataSpectrum: " + bCombineDataSpectrum);
		System.out.println("bOverwriteInstrumentGeometry: " + bOverwriteInstrumentGeometry);
		System.out.println("sInstrumentGeometry: " + sInstrumentGeometry);
		System.out.println("bAddNexusAndGo: " + bAddNexusAndGo);
		System.out.println("sAddNexusAndGoString: " + sAddNexusAndGoString);
		System.out.println("sGoSequentiallyString: " + sGoSequentiallyString);
		
	}
	
}
