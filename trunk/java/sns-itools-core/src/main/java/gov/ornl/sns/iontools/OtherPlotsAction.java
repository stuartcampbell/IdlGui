package gov.ornl.sns.iontools;

public class OtherPlotsAction {

  static boolean bThreadSafe;
  static int tBinMin = 0;
  static int tBinMax = 0;
  
  static void selectDesiredPlot() {
  
    bThreadSafe = true;
        
    int iTOFSelected = CreateOtherPlotsPanel.list1OfOtherPlotsComboBox.getSelectedIndex();
    int iXYSelected = CreateOtherPlotsPanel.list2OfOtherPlotsComboBox.getSelectedIndex();
    int iIndex = iTOFSelected * 7 + iXYSelected;
    switch (iIndex) {
      case 0:  //f( ---, ---, ---)
      case 7:  //f( TOf, ---, ---)
      case 14 ://f( TOFo, ---, ---)
        bThreadSafe = false;
        executePlot(iIndex);
        break;
      case 1:  //f( ---, SumX, SumY)
        bThreadSafe = false;
      case 8:  //f( TOF, SumX, SumY)
      case 15: //f( TOFo, SumX, SumY)
        executePlot(iIndex);
        break;
      case 2:  //f( ---, Xo, SumY)
        bThreadSafe = false;
      case 9:  //f( TOF, Xo, SumY)
      case 16: //f( TOFo, Xo, SumY)
        executePlot(iIndex);
        break;
      case 3:  //f( ---, SumX, Yo)
        bThreadSafe = false;
      case 10: //f( TOF, SumX, Yo)
      case 17: //f( TOFo, SumX, Yo)
        executePlot(iIndex);
        break;
      case 4:  //f( ---, SignalSelection)
        bThreadSafe = false;
      case 11: //f( TOF, SignalSelection)
      case 18: //f( TOFo, SignalSelection)
        executePlot(iIndex);
        break;
      case 5:  //f( ---, BackSelection)
        bThreadSafe = false;
      case 12: //f( TOF, BackSelection)
      case 19: //f( TOFo, BackSelection)
        executePlot(iIndex);
        break;
      case 6:  //f( ---, Back2Selection)
        bThreadSafe = false;
      case 13: //f( TOF, Back2Selection)
      case 20: //f( TOFo, Back2Selection)
        executePlot(iIndex);
        break;
      default:
      }
      
    //make various fields visible or invisible.
    OtherPlotsUpdateGui.updateGUI(iIndex); 
  }
  
  /*
   * This functions takes care of the multiThreading launching
   */
  static void startThread(String cmd) {
  
  //plot will run in another thread
  SubmitOtherPlots run = new SubmitOtherPlots(cmd);
  Thread runThread = new Thread(run,"plot in progress");
  runThread.start();
      
  }
    
  /*
   * This function clears the plot
   */
  static void clearPlot(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    startThread(cmd);
  }
  
  /*
   * This function redirects the index to the rigth cmd and messages
   */
  static void executePlot(int index) {
    OtherPlotsCreateMessage.displayInfoMessage(index);
    String cmd = OtherPlotsCreateCmd.createCmd(index);
    OtherPlotsCreateMessage.displayMoreInfo(index);
    if (bThreadSafe) {
      startThread(cmd);
    } else {
      OtherPlotsCreateMessage.displayErrorMessage(index);
    }
  }
   
   
}