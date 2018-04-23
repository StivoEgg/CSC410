package csc410.hw3;
import java.io.*;
import java.util.*;

import soot.Local;
import soot.Unit;
import soot.ValueBox;
import soot.toolkits.graph.DirectedGraph;
import soot.toolkits.graph.UnitGraph;
import soot.toolkits.scalar.BackwardFlowAnalysis;
import soot.toolkits.scalar.FlowSet;
import soot.toolkits.scalar.ArraySparseSet;

class UpwardExposedUses
		extends BackwardFlowAnalysis<Unit, FlowSet<Map.Entry<Local, Unit>>>
{

	private FlowSet<Map.Entry<Local, Unit>> emptySet;
	private FlowSet<Local> emptyLocalSet;

	public UpwardExposedUses(DirectedGraph g) {
		// First obligation
		super(g);

		// Create the emptyset
		emptySet = new ArraySparseSet<Map.Entry<Local, Unit>>();
		emptyLocalSet = new ArraySparseSet<Local>();

		// Second obligation
		doAnalysis();

		try {outPut((UnitGraph) g);}
		catch (IOException ioe) {}

	}

	private void outPut(UnitGraph g) throws IOException {
		Iterator<Unit> unitIt = g.iterator();

		File file = new File("exposed-uses.txt");
		file.createNewFile();
		FileWriter writer = new FileWriter(file);

		while (unitIt.hasNext()) {

			Unit s = unitIt.next();
			FlowSet<Map.Entry<Local, Unit>> set = getFlowAfter(s);

			for (Map.Entry entry: set) {
				writer.write(s.toString() + '\n');
				writer.write(entry.getValue().toString()+ '\n');
				writer.write(entry.getKey().toString() + '\n');
			}

		}
		writer.close();
	}


	// This method performs the joining of successor nodes
	// Since live variables is a may analysis we join by union
	@Override
	protected void merge(FlowSet<Map.Entry<Local, Unit>> inSet1,
						 FlowSet<Map.Entry<Local, Unit>> inSet2,
						 FlowSet<Map.Entry<Local, Unit>> outSet)
	{
		inSet1.union(inSet2, outSet);
	}


	@Override
	protected void copy(FlowSet<Map.Entry<Local, Unit>> srcSet,
						FlowSet<Map.Entry<Local, Unit>> destSet)
	{
		srcSet.copy(destSet);
	}


	// Used to initialize the in and out sets for each node. In
	// our case we build up the sets as we go, so we initialize
	// with the empty set.
	@Override
	protected FlowSet<Map.Entry<Local, Unit>> newInitialFlow()  {
		return emptySet.clone();
	}


	// Returns FlowSet representing the initial set of the entry
	// node. In our case the entry node is the last node and it
	// should contain the empty set.
	@Override
	protected FlowSet<Map.Entry<Local, Unit>> entryInitialFlow() {
		return emptySet.clone();
	}


	// Sets the outSet with the values that flow through the
	// node from the inSet based on reads/writes at the node
	// Set the outSet (entry) based on the inSet (exit)
	@Override
	protected void flowThrough(FlowSet<Map.Entry<Local, Unit>> inSet,
							   Unit node, FlowSet<Map.Entry<Local, Unit>> outSet) {

		FlowSet def = (FlowSet)emptyLocalSet.clone();
		for (ValueBox vb: node.getDefBoxes()) {
			if (vb.getValue() instanceof Local) {
				def.add(vb.getValue());
			}
		}

		FlowSet use = (FlowSet)emptyLocalSet.clone();
		for (ValueBox vb: node.getUseBoxes()) {
			if (vb.getValue() instanceof Local) {
				use.add(vb.getValue());
			}
		}

		for (Object x : use) {
			Map.Entry<Local, Unit> temp = new AbstractMap.SimpleEntry<>((Local) x, node);
			outSet.add(temp);
		}

		for (Map.Entry<Local, Unit> entry : inSet) {
			Local x = entry.getKey();
			if (!def.contains(x)){
				outSet.add(entry);
			}
		}
	}
}

