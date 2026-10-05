print("WELCOME TO THE");
print("");
print("REPRESENTATIVE IMAGE MAKING SCRIPT DERIVED FROM ---> OBJECT BASED COLOCALIZATION SEMI-AUTOMATED IMAGEJ JAVASCRIPT MACRO");
print("Date of completion------30th November 2023");
print("BROUGHT TO YOU BY------- AUTOPHAGY LAB-----------JNCASR, BENGALURU, KARNATAKA, INDIA");
print("CONTRIBUTORS:- MALLIKA, ASIMA, ANKIT, RITO, ANUSHKA, RAHUL, AKSHAYA, AARTI, CUCKOO, IRINE, RUCHIKA, PRIYADRSHINI, RAVI");
print("Acknowledgement:- Jishnu Goswami");
print("YessssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssSir");
print("LesssssssssssssssssssssssssssssssssssssssssssssssssssGO");

// Record the start time
startTime = getTime();

// PROMPT USER FOR INPUT AND OUTPUT FOLDERS
inputDir = "D:/n3_27x_nmjs_deconwolffed/CombinedChannels/" ;
outputDir = "C:/Users/rd12d/Downloads/AutomatedRepMakingNMJs/" ;

// GET LIST OF ALL FILES IN THE INPUT DIRECTORY
list = getFileList(inputDir);
// Turn on Batch Mode to process in the background
setBatchMode(true); 

// START BATCH PROCESSING LOOP
for (i = 0; i < list.length; i++) {
    // Check if the file is a .czi image
    if (endsWith(list[i], ".tif")) {
        ImgFile = list[i];
        fname = inputDir + ImgFile;
        
        print("Processing file " + (i+1) + " of " + list.length + ": " + ImgFile);

        // USING BIOFORMATS TO OPEN THE CZI FILE
        run("Bio-Formats", "open=[" + fname + "] autoscale color_mode=Colorized view=Hyperstack stack_order=XYCZT");
        originalTitle = getTitle();

        //run("Brightness/Contrast...");
        resetMinAndMax;
        //waitForUser("Look for the z-stacks of interest and take note of the slices.\nClick OK here, then enter the values in the 'Make Subset' dialog.");
        
        // Make Subset for the specified z-stack range
        //run("Make Subset...");
        
        // Dynamically get the name of the new subset window (no need to guess "-1" anymore)
        subsetTitle = getTitle(); 
        
        // Split channels on the new subset
        run("Split Channels");

        // Define dynamic names for the split channels
        C1_Name = "C1-" + subsetTitle; // Red Channel
        C2_Name = "C2-" + subsetTitle; // Green Channel
        C3_Name = "C3-" + subsetTitle; // Blue Channel

        // Convert to 8-bit
        selectWindow(C1_Name);
        run("8-bit");
        rename("RedChannel");
        //run("Grays");
        selectWindow(C2_Name);
        run("8-bit");
        rename("GreenChannel");
        //run("Grays");
        selectWindow(C3_Name);
        run("8-bit");
        rename("BlueChannel");
		//run("Grays");
        //**********************************************************************************************************************************//
        
        
        // SUBTRACTING RED CHANNEL (CHANNEL 1) BACKGROUND
//        selectWindow("RedChannel");
//        setTool("oval");
//        
//        run("Clear Results"); 
//        roiManager("reset");
//
//        waitForUser("Switch to the oval tool and draw the ROI manually to mark Blue background.\nAfter drawing, click OK.");
//        roiManager("Add");
//        roiManager("Select", 0);
//        run("Measure");
//        
//        // Calculate mean intensity
//        meanIntensity = getResult("Mean", 0);
//        roiManager("Show All");
//		roiManager("Show None");
//        
//        // Subtract mean intensity and multiply by factor
//        run("Subtract...", "value=" + meanIntensity + " stack");
//        factor = 255 / (255 - meanIntensity);
//        run("Multiply...", "value=" + factor + " stack");
//
//        // Clear ROI Manager for the next steps
//        roiManager("reset");
//        run("Clear Results");


        // SUBTRACTING GREEN CHANNEL (CHANNEL 1) BACKGROUND
        //selectWindow("GreenChannel");
        //setTool("oval");
        
        // Clear any previous results/ROIs to avoid taking the wrong mean
        //run("Clear Results"); 
        //roiManager("reset");

        //waitForUser("Switch to the oval tool and draw the ROI manually to mark Green background.\nAfter drawing, click OK.");
        //roiManager("Add");
        //roiManager("Select", 0);
        //run("Measure");
        
        // Calculate mean intensity
        //meanIntensity = getResult("Mean", 0);
        //roiManager("Show All");
		//roiManager("Show None");
        
        // Subtract mean intensity and multiply by factor
        //run("Subtract...", "value=" + meanIntensity + " stack");
        //factor = 255 / (255 - meanIntensity);
        //run("Multiply...", "value=" + factor + " stack");

        // SUBTRACTING BLUE CHANNEL (CHANNEL 2) BACKGROUND
        //selectWindow("BlueChannel");
        //setTool("oval");
        
        //run("Clear Results"); 
        //roiManager("reset");

        //waitForUser("Switch to the oval tool and draw the ROI manually to mark Blue background.\nAfter drawing, click OK.");
        //roiManager("Add");
        //roiManager("Select", 0);
        //run("Measure");
        
        // Calculate mean intensity
        //meanIntensity = getResult("Mean", 0);
        //roiManager("Show All");
		//roiManager("Show None");
        
        // Subtract mean intensity and multiply by factor
        //run("Subtract...", "value=" + meanIntensity + " stack");
        //factor = 255 / (255 - meanIntensity);
        //run("Multiply...", "value=" + factor + " stack");

        // Clear ROI Manager for the next steps
        //roiManager("reset");
        //run("Clear Results");

        //*******************************************************************************************************************************//

        // MAKING ROI WITH BLUE CHANNEL (CHANNEL 3)
        selectWindow("BlueChannel");
        run("Z Project...", "projection=[Max Intensity]");
        selectWindow("MAX_BlueChannel");
        resetMinAndMax;
		run("Enhance Contrast", "saturated=0.35");
        
//        waitForUser("Draw a rough ROI around NMJ in the Blue Channel");
//        setTool("freehand");
//        setThreshold(0, 255);
//        run("Threshold...");
//        waitForUser("Adjust the threshold using the slider.\nPress OK when done.");
//        
//        // Clear results before analyzing to ensure clean output
//        run("Clear Results");
//        run("Analyze Particles...", "size=30-Infinity show=Outlines clear summarize add");
//        saveAs("Results", outputDir + ImgFile + "_Blue-Properties.csv"); 
//        selectImage("Drawing of MAX_BlueChannel");
//        saveAs("Jpeg", outputDir + ImgFile + "_BlueChannel.jpg");
//        run("Clear Results");

        //*******************************************************************************************************************************//

        // CALCULATING THE MEAN INTENSITY OF GREEN CHANNEL (CHANNEL 2)
        selectWindow("GreenChannel");
        run("Z Project...", "projection=[Max Intensity]");
        selectWindow("MAX_GreenChannel");
        resetMinAndMax;
		run("Enhance Contrast", "saturated=0.35");
        
        // Apply the ROI created from the Blue channel
//        roiManager("Select", 0);
//        setThreshold(0, 255);
//        run("Threshold...");
//        waitForUser("Adjust the threshold using the slider for the Green Channel.\nPress OK when done.");
//        
//        run("Clear Results");
//        run("Analyze Particles...", "size=0.1-Infinity show=Outlines clear summarize");
//        saveAs("Results", outputDir + ImgFile + "_GreenChannel.csv"); 
//        
//        selectImage("Drawing of MAX_GreenChannel");
//        saveAs("Jpeg", outputDir + ImgFile + "_GreenChannel.jpg");
//        
//        // Save summary
//        selectWindow("Summary");
//        saveAs("Results", outputDir + ImgFile + "_SummaryGreenChannel.csv");
//        run("Close"); // Close summary window
//
//        // Clean up before next loop iteration
//        //roiManager("reset");
//        //run("Close All");
//        
//        print("Image " + ImgFile + " is successfully processed.");
        
        
        // CALCULATING THE MEAN INTENSITY OF RED CHANNEL (CHANNEL 2)
        selectWindow("RedChannel");
        run("Z Project...", "projection=[Max Intensity]");
        selectWindow("MAX_RedChannel");
        resetMinAndMax;
		run("Enhance Contrast", "saturated=0.35");
		
		
		
		
		//MERGING ALL THE CHANNELS 
		
		run("Merge Channels...", "c1=MAX_RedChannel c2=MAX_GreenChannel c3=MAX_BlueChannel create keep");
		// Add Scale Bar
        run("Scale Bar...", "width=20 height=20 thickness=10 font=40 bold overlay label");
		FinalMerged = getTitle(); 
		
		
		
		
//        
//        // Apply the ROI created from the Blue channel
//        roiManager("Select", 0);
//        setThreshold(0, 255);
//        run("Threshold...");
//        waitForUser("Adjust the threshold using the slider for the Green Channel.\nPress OK when done.");
//        
//        run("Clear Results");
//        run("Analyze Particles...", "size=0.1-Infinity show=Outlines clear summarize");
//        saveAs("Results", outputDir + ImgFile + "_RedChannel.csv"); 
//        
        selectImage(FinalMerged);
        saveAs("Jpeg", outputDir + ImgFile + "_MergedRep.jpg");

        // -------------------------------------------------------------------------------- //
        // NEW CODE: Add scale bars to individual channels and save them
        // -------------------------------------------------------------------------------- //

        selectWindow("MAX_RedChannel");
        run("Scale Bar...", "width=20 height=20 thickness=10 font=40 bold overlay label");
        saveAs("Jpeg", outputDir + ImgFile + "_MAX_RedChannel.jpg");

        selectWindow("MAX_GreenChannel");
        run("Scale Bar...", "width=20 height=20 thickness=10 font=40 bold overlay label");
        saveAs("Jpeg", outputDir + ImgFile + "_MAX_GreenChannel.jpg");

        selectWindow("MAX_BlueChannel");
        run("Scale Bar...", "width=20 height=20 thickness=10 font=40 bold overlay label");
        saveAs("Jpeg", outputDir + ImgFile + "_MAX_BlueChannel.jpg");
        // -------------------------------------------------------------------------------- //

//        
//        // Save summary
//        selectWindow("Summary");
//        saveAs("Results", outputDir + ImgFile + "_SummaryRedChannel.csv");
//        run("Close"); // Close summary window
//
//        // Clean up before next loop iteration
        roiManager("reset");
        run("Close All");
//        
//        print("Image " + ImgFile + " is successfully processed.");
        
    }
}

// Turn GUI updates back on
setBatchMode(false);

//******************************************************************************************************************************//
print("All .czi files have been processed.");
print("Results, Summaries, and Image files are saved at: " + outputDir);

// Calculate the elapsed time
elapsedTime = (getTime() - startTime) / 1000;
print("Total script execution time: " + elapsedTime + " seconds");
print("YessssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssSir");
print("SheeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeSh");