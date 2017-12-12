package asignacionCfi;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Random;

import aima.core.search.framework.problem.GoalTest;
import aima.core.search.local.FitnessFunction;
import aima.core.search.local.Individual;

/**
 * La representación de los indivuduos es: array de 16 posiciones que
 * corresponde con el número del turno y su valor será un número que
 * representa al profesor. Si el valor es -1, indica que el turno está vacío.
 * el cruce es por un punto. Vemos cuantos turnos hay, si sobra, quitamos turnos
 * aleatoriamente y no llega a lo establecido, añadimos aleatoriamente un
 * profesor en una posición. en el fitness hay que intervenir turnos
 * equilibrados y preferencias fitness = turnosEquil + Preferencias + 1
 * turnosEquil = maxTurnos - minTurnos (podemos contar el número de profesor
 * desequilibrado) preferencias: número de preferencias / número de turnos
 * estado objetivo: el número de turno es el que pide y cada profesor tiene
 * asignado un turno de preferencia y los turnos están equilibrados.
 * */
public class CFIGenAlgoUtil {
	
	public FitnessFunction<Integer> getFitnessFunction(int turnsToAssign,
			List<List<Integer>> restrictionsList,
			List<List<Integer>> preferencesList) {
		return new CFIFitnessFunction(turnsToAssign, preferencesList,
				preferencesList);
	}

	public GoalTest getGoalTest(int turnsToAssign,
			List<List<Integer>> restrictionsList,
			List<List<Integer>> preferencesList) {
		return new CFIGoalTest(turnsToAssign, preferencesList,
				preferencesList);
	}

	public Individual<Integer> generateRandomIndividual(int turnsToAssign,
			List<List<Integer>> restrictionsList) {
		if (turnsToAssign > CFIDemo.TOTAL_TURNS) {
			return null;
		}
		int unAvailableTurns = 0; 
		for (int i = 0; i < restrictionsList.size(); ++i) {
			unAvailableTurns += restrictionsList.get(i).size();
		}
		if (CFIDemo.TOTAL_TURNS * restrictionsList.size() - unAvailableTurns < turnsToAssign) {
			return null;
		}
		List<Integer> representation = new ArrayList<Integer>();
		for (int i = 0; i < CFIDemo.TOTAL_TURNS; ++i) {
			representation.add(-1);
		}
		for (int i = 0; i < turnsToAssign; ++i) {
			int randomTurn, randomTeacher;
			do {
				randomTurn = new Random().nextInt(CFIDemo.TOTAL_TURNS);
				randomTeacher = new Random().nextInt(restrictionsList.size());
			} while (representation.get(randomTurn) != -1 || restrictionsList.get(randomTeacher).contains(randomTurn));
			representation.set(randomTurn, randomTeacher);			
		}
		return new Individual<Integer>(representation);
	}

	public Collection<Integer> getFiniteAlphabetForSize(int size) {
		Collection<Integer> fab = new ArrayList<Integer>();

		for (int i = 0; i < size; i++) {
			fab.add(i);
		}
		return fab;
	}

	public class CFIFitnessFunction implements FitnessFunction<Integer> {

		private int turnsToAssign;
		private List<List<Integer>> restrictionsList;
		private List<List<Integer>> preferencesList;

		public CFIFitnessFunction(int turnsToAssign,
				List<List<Integer>> restrictionsList,
				List<List<Integer>> preferencesList) {
			this.turnsToAssign = turnsToAssign;
			this.restrictionsList = restrictionsList;
			this.preferencesList = preferencesList;
		}

		@Override
		public double apply(Individual<Integer> individual) {
			double fitness = 0;
			List<Integer> representation = individual.getRepresentation();
			fitness = assignedTurns(representation);
			if (fitness == turnsToAssign) {
				// All turns are correctly assigned
				fitness += fitnessImprove(representation);
				// Add 1 to fitness to avoid fitness finishes with value 0
				return fitness + 1;
			} else {
				return 0.1;
			}
		}

		/**
		 * Returns number of turns assigned correctly, verifying restrictions.
		 * 
		 * @param representation
		 * @return
		 */
		private int assignedTurns(List<Integer> representation) {
			int turns = 0;
			for (int i = 0; i < representation.size(); ++i) {
				if (representation.get(i) != -1
						&& !restrictionsList.get(representation.get(i))
								.contains(i)) {
					// If turns is assigned and teacher has not restriction, is
					// a correct assignment.
					++turns;
				}
			}
			return turns;
		}

		/**
		 * Verifies preferences and balance of assignment
		 * 
		 * @param representation
		 * @return
		 */
		private int fitnessImprove(List<Integer> representation) {
			int preferencesAssigned = 0;
			List<Integer> turnsTeachers = new ArrayList<Integer>();
			for (int i = 0; i < restrictionsList.size(); ++i) {
				turnsTeachers.add(0);
			}
			for (int i = 0; i < representation.size(); ++i) {
				if (representation.get(i) != -1) {
					// Add a turn to correspondent teacher
					turnsTeachers.set(representation.get(i),
							turnsTeachers.get(representation.get(i)) + 1);
					if (preferencesList.get(representation.get(i)).contains(i)) {
						// If turn is a preference for a teacher, add one
						++preferencesAssigned;
					}
				}
			}
			return preferencesAssigned - balancedAssignment(turnsTeachers);
		}

		/**
		 * Verifies balance of assignment
		 * 
		 * @param turnsTeachers
		 * @return
		 */
		private int balancedAssignment(List<Integer> turnsTeachers) {
			int penalization = 0;
			double average = ((double) turnsToAssign)
					/ ((double) turnsTeachers.size());
			average = Math.ceil(average);
			for (int i = 0; i < turnsTeachers.size(); ++i) {
				if (turnsTeachers.get(i) > average) {
					penalization += turnsTeachers.get(i) - (int) average;
				}
			}
			return penalization;
		}
	}

	public class CFIGoalTest implements GoalTest {

		private int turnsToAssign;
		private List<List<Integer>> restrictionsList;
		private List<List<Integer>> preferencesList;

		public CFIGoalTest(int turnsToAssign,
				List<List<Integer>> restrictionsList,
				List<List<Integer>> preferencesList) {
			this.turnsToAssign = turnsToAssign;
			this.restrictionsList = restrictionsList;
			this.preferencesList = preferencesList;
		}

		@SuppressWarnings("unchecked")
		@Override
		public boolean isGoalState(Object individual) {
			CFIFitnessFunction info = new CFIFitnessFunction(turnsToAssign,
					restrictionsList, preferencesList);
			return info.apply((Individual<Integer>) individual) == 2 * turnsToAssign + 1;
		}
	}
}
