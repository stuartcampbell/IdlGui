#include "Event_to_Histo.hpp"

/*
 * $Id: Event_to_Histo.cpp 28 2006-05-02 17:45:45Z j35 $
 */

using namespace std;
using namespace TCLAP;

/**
 * \brief This function initializes an array
 * 
 * \param histo_array the array to be initialized
 * \param size the size of the array
 *
 */
void initialize_array(int32_t * histo_array, 
                      const int size)
{
  for (int32_t i=0 ; i<size ; ++i)
    {
      histo_array[i]=0;
     }
  
  return;   
}

/**
 * \brief This function generates the final histogram array
 *
 * \param file_size (INPUT) is the size of the file to be read
 * \param new_Nt (INPUT) is the new number of time bins
 * \param pixel_number (INPUT) is the number of pixelids
 * \param time_rebin_width (INPUT) is the new time bin width
 * \param binary_array (INPUT) is the array of values coming from the event
 *  binary file
 * \param histo_array (OUTPUT) is the histogram array
 * \param histo_array_size (INPUT) is the size of the histogram array
 * \param debug (INPUT) is a switch that trigger or not the debugging tools
 */
void generate_histo(const int32_t file_size,
                    const int32_t new_Nt,
                    const int32_t pixelnumber,
                    const int32_t time_rebin_width,
                    const int32_t * binary_array,
                    int32_t * histo_array,
                    const int32_t histo_array_size,
                    const bool debug)
{
  int32_t pixelid;
  int32_t time_stamp;

  //initialize histo array
  initialize_array(histo_array,
                   histo_array_size);

  //loop over entire binary file data
  for (size_t i=0 ; i<file_size/2; i++)
  {
      pixelid = binary_array[2*i+1];
      time_stamp = int32_t(floor((binary_array[2*i]/10)/time_rebin_width));

      //remove data that are oustide the scope of range
      if (pixelid<0 || 
          pixelid>pixelnumber ||
          time_stamp<0 ||
          time_stamp>(time_rebin_width*(new_Nt-1)))
        {
          continue;
        }
      //record data that is inside the scope of range
      histo_array[time_stamp+pixelid*new_Nt]+=1;
  }
  
  return;
}

/**
 * \brief This program takes an event binary file and according to the 
 * arguments provided, creates a histo binary file.
 */
int32_t main(int32_t argc, char *argv[])
{
  try
    {
      // Setup the command-line parser object
      CmdLine cmd("Command line description message", ' ', VERSION_TAG);

      // Add command-line options
      ValueArg<string> altoutpath("a", "alternate_output", 
                                  "Alternate path for output file",
                                  false, "", "path", cmd);

      SwitchArg debugSwitch("d", "debug", "Flag for debugging program",
                            false, cmd);

      SwitchArg swapiSwitch ("", "swap_input", 
                            "Flag for swapping data of input file",
                            false, cmd);
      
      SwitchArg swapoSwitch ("", "swap_output",
                             "Flag for swapping data of output file",
                             false, cmd);

      ValueArg<int32_t> pixelnumber ("p", "number_of_pixels",
                                     "Number of pixels for this run",
                                     true, -1, "pixel number", cmd);

      ValueArg<int32_t> timebinnumber("t", "time_bin_number", 
                                      "Number of time bin in event file",
                                      true, -1, "time bin number", cmd);

      ValueArg<int32_t> timerebinwidth("l","linear",
                                       "width of rebin linear time bin",
                                       true, -1, "new linear time bin", cmd);
      
      ValueArg<int32_t> timebinwidth("w", "time_bin_width",
                                     "input binary file time bin width",
                                     false, 100, 
                                     "width of event file time bin", cmd);
      
      UnlabeledMultiArg<string> event_file_vector("event_file",
                                                  "Name of the event file",
                                                  "filename", cmd);
      
      SwitchArg showDataArg("o", "showdata", "Print the values in the file",
                            false, cmd);
      
      ValueArg<int32_t> n_values("n", "input_file_values",
                               "number of values of input files to print out",
                                 false, 5, "values to output", cmd);
      
      // Parse the command-line
      cmd.parse(argc, argv);
      
      // isolate path from file name and create output file name
      string input_filename;
      string output_filename("");
      string path; 
      vector<string> input_file_vector = event_file_vector.getValue();
      string input_file = input_file_vector[0];
      bool debug = debugSwitch.getValue();
      
      path_input_output_file_names(input_file,
                                   input_filename,
                                   path,
                                   altoutpath.getValue(),
                                   output_filename,
                                   debug);

      int32_t file_size;
      int32_t * binary_array;

      file_size = 
        read_event_file_and_populate_binary_array(input_file,
                                                  input_filename,
                                                  swapiSwitch.getValue(),
                                                  debug,
                                                  n_values.getValue(),
                                                  binary_array);

      int32_t time_bin_number = timebinnumber.getValue(); 
      int32_t time_rebin_width = timerebinwidth.getValue();
      int32_t pixel_number = pixelnumber.getValue();
      int32_t new_Nt = int32_t(floor((time_bin_number*timebinwidth.getValue())
                                     /time_rebin_width));
      int32_t histo_array_size = new_Nt * pixel_number;
      int32_t * histo_array = new int32_t [histo_array_size];
      
      //generate histo binary data array
      generate_histo(file_size,
                     new_Nt,
                     pixelnumber.getValue(),
                     time_rebin_width,
                     binary_array,
                     histo_array,
                     histo_array_size,
                     debug);

      if(swapoSwitch.getValue())
        {
          swap_endian(histo_array_size, histo_array);
        }

      if(showDataArg.getValue())
        {
          
        }

      // write new histogram file
      std::ofstream histo_file(output_filename.c_str(),
                               std::ios::binary);
      histo_file.write((char*)(histo_array),
                       SIZEOF_INT32_T*histo_array_size);
      histo_file.close();

      delete histo_array;
      delete binary_array;

    }
  catch (ArgException &e)
    {
      cerr << "Error: " << e.error() << " for arg " << e.argId() << endl;
    }
  
  return 0;
}


                        
