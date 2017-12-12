package asignacionCfi;

import java.util.Collection;

import aima.core.search.local.GeneticAlgorithm;

public class CFIGeneticAlgorithm extends GeneticAlgorithm<Integer> {

	public CFIGeneticAlgorithm(int individualLength,
			Collection<Integer> finiteAlphabet, double mutationProbability) {
		super(individualLength, finiteAlphabet, mutationProbability);
	}

}
