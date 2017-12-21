package asignacionCfi;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Random;

import aima.core.search.local.GeneticAlgorithm;
import aima.core.search.local.Individual;

public class CFIGeneticAlgorithm extends GeneticAlgorithm<Integer> {
	
	protected int turnsToAssign;
	protected List<List<Integer>> restrictionsList;

	public CFIGeneticAlgorithm(int individualLength,
			Collection<Integer> finiteAlphabet, double mutationProbability,
			int turnsToAssign, List<List<Integer>> restrictionsList) {
		super(individualLength, finiteAlphabet, mutationProbability);
		this.turnsToAssign = turnsToAssign;
		this.restrictionsList = restrictionsList;
	}

	protected Individual<Integer> reproduce(Individual<Integer> x,
			Individual<Integer> y) {
		List<Integer> child = new ArrayList<Integer>();

		// Initialize child
		for (int i = 0; i < individualLength; ++i) {
			child.add(-1);
		}

		int pivot = new Random().nextInt(CFIDemo.TOTAL_TURNS);
		int turns = 0;

		// Child's head from x
		for (int i = 0; i < pivot; i++) {
			child.set(i, x.getRepresentation().get(i));
			if (child.get(i) != -1) {
				++turns;
			}
		}

		// Child's tail from x
		for (int i = pivot; i < individualLength && turns < turnsToAssign; ++i) {
			child.set(i, y.getRepresentation().get(i));
			if (child.get(i) != -1) {
				++turns;
			}
		}
		pivot = 0;
		// If child have less assigned turns than turnsToAssign
		while (turns < turnsToAssign) {
			if (child.get(pivot) == -1
					&& y.getRepresentation().get(pivot) != -1) {
				child.set(pivot, y.getRepresentation().get(pivot));
				++turns;
			}
			++pivot;
		}
		return new Individual<Integer>(child);
	}

	protected Individual<Integer> mutate(Individual<Integer> child) {
		List<Integer> mutatedRepresentation = new ArrayList<Integer>(
				child.getRepresentation());
		
		int randomOccupiedPosition = new Random().nextInt(CFIDemo.TOTAL_TURNS);
		while (mutatedRepresentation.get(randomOccupiedPosition) == -1) {
			randomOccupiedPosition = (randomOccupiedPosition + 1) % CFIDemo.TOTAL_TURNS;
		}
		otherTeacherAvailable(randomOccupiedPosition, mutatedRepresentation);
		return new Individual<Integer>(mutatedRepresentation);
	}
	/**
	 * Dado un turno y el profesor asociado, lo cambia por otro si es posible
	 * @param turn
	 * @param teacher
	 * @return
	 */
	private void otherTeacherAvailable(int turn, List<Integer> mutatedRepresentation) {
		List<Integer> availableTeachers = new ArrayList<Integer>();
		for (int i = 0; i < restrictionsList.size(); ++i) {
			if (!restrictionsList.get(i).contains(turn) && mutatedRepresentation.get(turn) != i) {
				availableTeachers.add(i);
			}
		}
		if (!availableTeachers.isEmpty()) {
			mutatedRepresentation.set(turn, availableTeachers.get(new Random()
					.nextInt(availableTeachers.size())));
		}
	}

}
