package asignacionCfi;

import java.util.Collection;
import java.util.List;

import aima.core.search.local.GeneticAlgorithm;

public class CFIGeneticAlgorithm extends GeneticAlgorithm<Integer> {
	protected int turnsToAssign;
	protected List<List<Integer>> restrictionsList;

	public CFIGeneticAlgorithm(int individualLength, Collection<Integer> finiteAlphabet, double mutationProbability,
			int turnsToAssign, List<List<Integer>> restrictionsList) {
		super(individualLength, finiteAlphabet, mutationProbability);
		this.turnsToAssign = turnsToAssign;
		this.restrictionsList = restrictionsList;
	}

}
