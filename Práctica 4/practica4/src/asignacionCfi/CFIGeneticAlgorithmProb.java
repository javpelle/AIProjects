package asignacionCfi;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import aima.core.search.local.FitnessFunction;
import aima.core.search.local.Individual;

public class CFIGeneticAlgorithmProb extends CFIGeneticAlgorithm {

	protected double reproductionProbability;

	public CFIGeneticAlgorithmProb(int individualLength,
			Collection<Integer> finiteAlphabet, double mutationProbability,
			int turnsToAssign, List<List<Integer>> restrictionsList,
			double reproductionProbability) {

		super(individualLength, finiteAlphabet, mutationProbability,
				turnsToAssign, restrictionsList);
		this.reproductionProbability = reproductionProbability;
	}

	protected List<Individual<Integer>> nextGeneration(
			List<Individual<Integer>> population,
			FitnessFunction<Integer> fitnessFn) {

		List<Individual<Integer>> newPopulation = new ArrayList<Individual<Integer>>(
				population.size());
		for (int i = 0; i < population.size(); i++) {
			Individual<Integer> x = randomSelection(population, fitnessFn);
			Individual<Integer> y = randomSelection(population, fitnessFn);
			Individual<Integer> child;
			if (random.nextDouble() <= reproductionProbability) {
				child = reproduce(x, y);
				if (random.nextDouble() <= mutationProbability) {
					child = mutate(child);
				}
			} else {
				child = x;
			}
			newPopulation.add(child);
		}
		return newPopulation;
	}
}
