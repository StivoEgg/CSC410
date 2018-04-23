package csc410.hw3;

import soot.*;

/*** *** *** YOU DO NOT SUBMIT THIS FILE *** *** ***/
/*** *** *** PLEASE DON'T EDIT THIS FILE *** *** ***/

public class RunDataFlowAnalysis {
	public static void main(String[] args) {
		
		if (args.length == 0) {
			System.out.println("Usage: java csc410.hw3.RunDataFlowAnalysis class_to_analyse");
			System.exit(1);
		} else {
			System.out.println("Analyzing class: "+args[0]);
		}

		String mainClass = args[0];

		// You may have to update the class Path based on your OS and Java version 
		/*** *** YOU MAY EDIT THIS TO ADD THE PATH TO rt.jar (IF NEEDED) WHILE TESTING ON YOUR MACHINE *** ***/
		String classPath = "soot.jar:test";
		

		//Set up arguments for Soot
		String[] sootArgs = {
			"-cp", classPath, "-pp", 	// sets the class path for Soot
			"-allow-phantom-refs",		// in case certain references are not correct (older versions of Java)
			"-w", 						// Whole program analysis, necessary for using Transformer
			"-src-prec", "c",			// Specify type of source file
			"-main-class", mainClass,	// Specify the main class 
			"-f", "J", 					// Specify type of output file
			mainClass 
		};

		// Create transformer for analysis
		AnalysisTransformer analysisTransformer = new AnalysisTransformer();

		// Add transformer to appropriate Pack in PackManager. PackManager will run all Packs when main function of Soot is called
		PackManager.v().getPack("wjtp").add(new Transform("wjtp.dfa", analysisTransformer));

		// Call main function with arguments
		soot.Main.main(sootArgs);

	}
}
