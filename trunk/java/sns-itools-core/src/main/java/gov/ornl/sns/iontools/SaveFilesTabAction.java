package gov.ornl.sns.iontools;

import java.util.Hashtable;
import java.util.Vector;
import com.rsi.ion.*;

import java.util.List;

public class SaveFilesTabAction {

  static int         iNbrOfFiles = 0;
  static Vector      vListOfFiles;
  static Vector      vListOfFilesAdded;
  static String[]    sListOfFiles;
  static String[]    sCompleteListOfFiles;
  static List        lListOfFilesAdded;
  static IONVariable ionUcams;
  static IONVariable ionTmpFolder;
  static IONVariable ionFileName;
  static IONVariable ionNbrLineDisplayed;
  static StoreFilesToSavePreview[] sFilePreview;
  static Hashtable<String, List<String>>   sHashtableOfFiles;
    
  /*
   * This function upate the list of files to transfered
   */
  static void updateListOfFilesToTransfer(boolean bFilesChanged) {
  
    try {
    
      if (!ParametersToKeep.bThreadInProcess &&
        !ParametersToKeep.bFirstRunEver) {
      
        sListOfFiles = getListOfFiles();
        sCompleteListOfFiles = sListOfFiles;
      
        iNbrOfFiles = sListOfFiles.length; //nbr of files to list
//    for (String file:sListOfFiles) {
//      System.out.println(file);
//    }
        if (!DataReduction.transferPidFilesCheckBox.isSelected()) {
          removePidFilesFromList(sListOfFiles);
        }     
        if (!DataReduction.transferDataReductionFileCheckBox.isSelected()) {
          removeDataReductionFilesFromList(sListOfFiles);
        } 
        if (!DataReduction.transferExtraPlotsCheckBox.isSelected()) {
          removeExtraPlotsFilesFromList(sListOfFiles);
        } 
        
        removeTmpHistoFileFromList(sListOfFiles);
        
        vListOfFiles = new Vector();
        vListOfFiles = getVectorListOfFiles(sListOfFiles);
        DataReduction.filesToTransferList.setListData(vListOfFiles);
      
        if (bFilesChanged) {
          //this part will store the preview of all the files everytime we want a refresh
          if (SaveFilesTabAction.iNbrOfFiles != 0) { //don't do anything when nothing to see
            StoreFilesToSavePreview.createHashtableOfFilesToSave();
          }
        }
      }
    } catch (Exception e) {};
  }
 
  
  /*
   * Get list of files in String array
   */
  static String[] getListOfFiles() {
    return UtilsFunction.getListOfFiles();
  }
  
  /*
   * transfer string array into vector 
   */
  static Vector getVectorListOfFiles(String[] listFiles) {
  
    for (int i=0; i<(listFiles.length); i++) {
      vListOfFiles.add(listFiles[i]);
      }
    return vListOfFiles;
  }
  
  /*
   * transfer list array into vector 
   */
  static Vector getVectorListOfFiles(List listFiles) {
    
    for (int i=0; i<(listFiles.size()); i++) {
      vListOfFilesAdded.add(listFiles.get(i));
      }
    return vListOfFilesAdded;
  }

  /*
   * Function that call the IDL command to transfer the file
   */
  static void transferFile() {
    
    //get selected indices
    int[] iSelection = DataReduction.filesToTransferList.getSelectedIndices();
    lListOfFilesAdded = new java.util.ArrayList();
    
    //list of files selected and transfer them one at a time
    for (int i=0; i<iSelection.length; i++) {
      String cmd = createCmd(sListOfFiles[iSelection[i]]);
      IonUtils.executeCmd(cmd);
      addFileInRightBox(sListOfFiles[iSelection[i]]); //add files into right box
    }
    
  }
  
  /*
   * Create the cmd that will be run through ION_JAVA to copy/transfer the files
   */
  static String createCmd(String fileName) {
    
    ionUcams     = new IONVariable(DataReduction.remoteUser);
    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName  = new IONVariable(fileName);
    
    String cmd = "MOVE_FILE, ";
    cmd += ionUcams + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionFileName;
    return cmd;
    
  }
  
  /*
   * This function add the file name in the right box 
   */
  static void addFileInRightBox(String fileNameToAdd) {
    lListOfFilesAdded.add(fileNameToAdd);
    vListOfFilesAdded = new Vector();
    vListOfFilesAdded = getVectorListOfFiles(lListOfFilesAdded);
    DataReduction.filesTransferedList.setListData(vListOfFilesAdded);    
  }
  
/*
 * Function that remove the pid files from the list
 */  
  static void removePidFilesFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!file.endsWith(IParameters.PID_FILE_EXTENSION)) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
}
 
  /*
   * Function that remove the data reduction files from list
   */
  static void removeDataReductionFilesFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!(file.endsWith(IParameters.TXT_FILE_EXTENSION) &&
          !file.endsWith(IParameters.PID_FILE_EXTENSION))) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
  }
  
  /*
   * Function that remove the extra plots files from list
   */
  static void removeExtraPlotsFilesFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!file.endsWith(IParameters.SR_EXTENSION) &&
          !file.endsWith(IParameters.BS_EXTENSION) &&
          !file.endsWith(IParameters.SRB_EXTENSION) &&
          !file.endsWith(IParameters.NR_EXTENSION) &&
          !file.endsWith(IParameters.BRN_EXTENSION)) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
  }
 
  /*
   * Function that remove the tmp histo file from list
   */
  static void removeTmpHistoFileFromList(String[] sListOfFiles) {
    List tmpListOfFiles = new java.util.ArrayList();
    for (String file:sListOfFiles) {
      if (!file.endsWith(IParameters.TMP_HISTO_FILE_EXTENSION)) {
        tmpListOfFiles.add(file);
      } 
    }
    convertListIntoString(tmpListOfFiles);
  }
  
  /*
   * this function converts a list into a String[]
   */
  static void convertListIntoString(List tmpListOfFiles) {
    int tmpSize = tmpListOfFiles.size();
    String[] tmpArray = new String[tmpSize];
    for (int i=0; i<tmpSize; i++) {
      tmpArray[i]=tmpListOfFiles.get(i).toString();
    }
    sListOfFiles = tmpArray;
  }
  
  /*
   * this function tells if the mode is automatic or not
   */
  static boolean isTransferModeAutomatic() {
    return DataReduction.automaticFilesTransferRadioButton.isSelected();
  }
  
  /*
   * This function copy all the files created during the current session 
   * to the home directory when the automatic mode is selected
   */
  static void transferAllFilesFromCurrentSession() {
    if (isTransferModeAutomatic()) { //mode is automatic
      sListOfFiles = getListOfFiles();
      for (int i=0; i<sListOfFiles.length; i++) {
        String cmd = createCmd(sListOfFiles[i]);
        IonUtils.executeCmd(cmd);
      }
    }
  }

  /*
   * this function displays the preview of the selected file in the 
   * message box 
   */
  static void displaySelectedFileInfo(int iIndex) {

    try {
      List<String> value = SaveFilesTabAction.sHashtableOfFiles.get(sCompleteListOfFiles[iIndex]);
      String[] myStringArray = value.toArray(new String[0]);
      String sFileName = sCompleteListOfFiles[iIndex];
      SaveFilesTabAction.displayedLabelMessage(sFileName);
      SaveFilesTabAction.displayMessageInInfoBox(myStringArray); 
    } catch (Exception e) {};
  }
  
  /*
   * This function create the cmd for the xml (.rmd) file through IDL.
   * The full contains of the file will be displayed
   */
  static String createSaveXmlFileInfoCmd(String sFileName) {
  
    //update nbr of lines to displayed
    SettingsTabAction.validateXmlTextField();
    
    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName  = new IONVariable(sFileName);
    ionNbrLineDisplayed = new IONVariable(ParametersToKeep.iNbrInfoLinesXmlToDisplayed);
        
    String cmd = "result = DISPLAY_XML_FILE_INFO( ";
    cmd += ionFileName + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionNbrLineDisplayed + ")";
    
    return cmd;
  }
    
   /*
   * This function creates the cmd that will be run through IDL to get
   * the first line of the given file
   */
  static String createSaveFileInfoCmd(String sFileName) {
   
    //update nbr of lines to displayed
    SettingsTabAction.validateNotXmlTextField();

    ionTmpFolder = new IONVariable(DataReduction.sTmpFolder);
    ionFileName  = new IONVariable(sFileName);
    ionNbrLineDisplayed = new IONVariable(ParametersToKeep.iNbrInfoLinesNotXmlToDisplayed);
        
    String cmd = "result = DISPLAY_FILE_INFO( ";
    cmd += ionFileName + ",";
    cmd += ionTmpFolder + ",";
    cmd += ionNbrLineDisplayed + ")";
    
    return cmd;
  }
  
  /*
   * this function displays the message in the text area box
   */
   static void displayMessageInInfoBox(String[] myResultArray) {
 
     int myResultArrayLength = myResultArray.length;
     myResultArray[0] += "\n";
       DataReduction.saveFileInfoTextArea.setText(myResultArray[0]);
       for (int i=1; i<myResultArrayLength; i++) {
         if (i != myResultArrayLength-1) {
             myResultArray[i]+="\n";
         }  
         DataReduction.saveFileInfoTextArea.append(myResultArray[i]);
       }
   }
   
   /*
    * Checks if the file is a binary file or not
    */
   static boolean isFileDatFile(String sFileName) {
     if (sFileName.endsWith(IParameters.DAT_EXTENSION)) {
       return true;
     } else {
       return false;
     }
   }
   
   /*
    * Checks if the file selected is an xml (.rmd file)
    */
   static boolean isFileRmdFile(String sFileName) {
     if (sFileName.endsWith(IParameters.RMD_EXTENSION)) {
       return true;
     } else {
       return false;
     }
   }
   
   /*
     * This function displays the given string in the label box just above
     * the preview text box
     */
    static void displayedLabelMessage(String sLabelMessage) {
      DataReduction.saveFileInfoMessageTextfield.setText(sLabelMessage);
    }
    
    /*
     * This function clears the save file info message box
     */
    static void clearInfoMessage() {
      DataReduction.saveFileInfoMessageTextfield.setText("");
    }
    
    /*
     * This function will rename the file currently previewed
     * by the name entered in the message text field
     */
    static void renameFileToSave() {
      String sNewFileName = DataReduction.saveFileInfoMessageTextfield.getText();
      String sOldFileName = getFirstFileSelected();
      
      System.out.println("new name is: " + sNewFileName);
      System.out.println("old name is: " + sOldFileName);
    }

    /*
     * This function will give the name of the first file selected
     */
    static String getFirstFileSelected() {
      //get selected indices
      int[] iSelection = DataReduction.filesToTransferList.getSelectedIndices();
      return sListOfFiles[iSelection[0]];
    }
    
    /*
     * This function will clear off the contain of the text field
     * and text area boxes
     */
    static void resetTextAreaField() {
      DataReduction.saveFileInfoMessageTextfield.setText("");
      DataReduction.saveFileInfoTextArea.setText("");
    }
}