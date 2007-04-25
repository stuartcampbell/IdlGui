/*
 * Copyright (c) 2007, J.-C. Bilheux <bilheuxjm@ornl.gov>
 * Spallation Neutron Source at Oak Ridge National Laboratory
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package gov.ornl.sns.iontools;

public interface IParameters {
	
		static final String DEFAULT_INSTRUMENT = "REF_L";
		static final String REF_L              = "REF_L";
		static final String REF_M              = "REF_M";
		
		//REF_L Data Reduction command line - flags 
		static final String REF_L_DATA_REDUCTION_CMD 		= "reflect_tofred";
		static final String REF_L_NORMALIZATION_FLAG 		= "--norm=";
		static final String REF_L_INSTRUMENT_GEOMETRY_FLAG 	= "--inst_geom=";
		static final String REF_L_COMBINE_FLAG 				= "--combine";
		static final String REF_L_SIGNAL_ROI_FILE_FLAG 		= "--signal-roi-file=";
		static final String REF_L_BKG_ROI_FILE_FLAG 		= "--bkg-roi-file=";
		static final String REF_L_NO_BKG_FLAG  				= "--no-bkg";
		static final String REF_L_NO_NORM_BKG             	= "--no-norm-bkg";
		static final String REF_L_DUMP_SPECULAR             = "--dump-specular";
		static final String REF_L_DUMP_SUB                  = "--dump-sub";
		static final String REF_L_DUMP_NORM                 = "--dump-norm";
		static final String REF_L_DUMP_NORM_BKG            	= "--dump-norm-bkg";
		
		//size of data reduction graphical window
		static final int DATA_REDUCTION_PLOT_X	            = 700;
		static final int DATA_REDUCTION_PLOT_Y              = 500;
		
		//constants used to define the main graphical display size
	 	//REF_L
		static final int NxRefl        			= 256;
	    static final int NxReflMin              = 0;
	    static final int NxReflMax              = 256;
		static final int NyRefl                 = 304;
	    static final int NyReflMin 				= 0;
	    static final int NyReflMax			    = 304;
	
	    //REF_M
	    static final int NxRefm                 = 304;
	    static final int NxRefmMin              = 0;
	    static final int NxRefmMax              = (303-255);
	    static final int NyRefm                 = 256;
	    static final int NyRefmMin              = 0;
	    static final int NyRefmMax              = (303-255);

	    static final String SIGNAL_STRING          = "signal";
	    static final String BACK1_STRING           = "back1";
	    static final String BACK2_STRING           = "back2";
	    static final String BACK_STRING            = "back";
	    static final String INFO_STRING            = "info";
	    
	    static final String PATH_TO_HOME           = "/SNS/users/";
	    static final String SEQUENCE_SEPARATOR     = "-";
	    static final String WORKING_PATH           = "~/local";
}
