package csc410.hw3;

import java.util.*;
import soot.*;
import soot.toolkits.graph.*;
import soot.toolkits.scalar.FlowSet;

/*** *** *** YOU DO NOT SUBMIT THIS FILE *** *** ***/
/*** *** *** PLEASE DON'T EDIT THIS FILE *** *** ***/

public class AnalysisTransformer extends SceneTransformer {

	@Override
	protected void internalTransform(String arg0, Map arg1) {

		// Get Main Method
		SootMethod sMethod = Scene.v().getMainMethod();

		// Create graph based on the method
		UnitGraph graph = new BriefUnitGraph(sMethod.getActiveBody());

		// Perform your Data Flow Analysis on the Graph
		// Note:: You should print all upward exposed uses to exposed-uses.txt
		// within the constructor of your class
		UpwardExposedUses analysis = new UpwardExposedUses(graph);

	}
}