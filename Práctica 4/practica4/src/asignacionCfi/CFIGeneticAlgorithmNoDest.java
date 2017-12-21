package asignacionCfi;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import aima.core.search.local.FitnessFunction;
import aima.core.search.local.Individual;

public class CFIGeneticAlgorithmNoDest extends CFIGeneticAlgorithm {

	protected double reproductionProbability;

	public CFIGeneticAlgorithmNoDest(int individualLength,
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
		for (int i = 0; i < population.size(); i += 2) {
			Individual<Integer> x = randomSelection(population, fitnessFn);
			Individual<Integer> y = randomSelection(population, fitnessFn);
			Individual<Integer> childX;
			Individual<Integer> childY;
			if (random.nextDouble() <= reproductionProbability) {
				childX = reproduce(x, y);
				childY = reproduce(y, x);
				if (fitnessFn.apply(x) + fitnessFn.apply(y) > fitnessFn.apply(childX) + fitnessFn.apply(childY)) {
					childX = x;
					childY = y;
				}
				if (random.nextDouble() <= mutationProbability) {
					childX = mutate(childX);
				}
				if (random.nextDouble() <= mutationProbability) {
					childY = mutate(childY);
				}
			} else {
				childX = x;
				childY = y;
			}
			newPopulation.add(childX);
			newPopulation.add(childY);
		}
		return newPopulation;
	}
}
