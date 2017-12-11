package asignacionCfi;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Random;

import aima.core.search.framework.problem.GoalTest;
import aima.core.search.local.FitnessFunction;
import aima.core.search.local.Individual;
import aima.core.util.datastructure.XYLocation;

/**
 * La representación de los indivuduos es: array de 16 posiciones que corresponde
 * con el número del turno y su valor será un número que representa al profesor.
 * Si el valor es -1, indica que el turno está vacío.
 * el cruce es por un punto. Vemos cuantos turnos hay, si sobra, quitamos turnos aleatoriamente
 * y no llega a lo establecido, añadimos aleatoriamente un profesor en una posición. 
 * en el fitness hay que intervenir turnos equilibrados y preferencias
 * fitness = turnosEquil + Preferencias + 1
 * turnosEquil = maxTurnos - minTurnos
 * (podemos contar el número de profesor desequilibrado)
 * preferencias: número de preferencias / número de turnos
 * estado objetivo: el número de turno es el que pide y cada profesor tiene asignado un turno de 
 * preferencia y los turnos están equilibrados.
 * */
public class CFIGenAlgoUtil {
	public static FitnessFunction<Integer> getFitnessFunction() {
		return new  CfiFitnessFunction();
	}
	
	public static GoalTest getGoalTest() {
		return new CfiGenAlgoGoalTest();
	}
	

	public static Individual<Integer> generateRandomIndividual(int size) {
		List<Integer> individualRepresentation = new ArrayList<Integer>();
		for (int i = 0; i < size; i++) {
			individualRepresentation.add(new Random().nextInt(size));
		}
		Individual<Integer> individual = new Individual<Integer>(individualRepresentation);
		return individual;
	}

	public static Collection<Integer> getFiniteAlphabetForSize(int size) {
		Collection<Integer> fab = new ArrayList<Integer>();

		for (int i = 0; i < size; i++) {
			fab.add(i);
		}

		return fab;
	}
	
	public static class CFIFitnessFunction implements FitnessFunction<Integer> {

		public double apply(Individual<Integer> individual) {
			double fitness = 0;

			NQueensBoard board = getBoardForIndividual(individual);
			int boardSize = board.getSize();

			// Calculate the number of non-attacking pairs of queens (refer to
			// AIMA
			// page 117).
			List<XYLocation> qPositions = board.getQueenPositions();
			for (int fromX = 0; fromX < (boardSize - 1); fromX++) {
				for (int toX = fromX + 1; toX < boardSize; toX++) {
					int fromY = qPositions.get(fromX).getYCoOrdinate();
					boolean nonAttackingPair = true;
					// Check right beside
					int toY = fromY;
					if (board.queenExistsAt(new XYLocation(toX, toY))) {
						nonAttackingPair = false;
					}
					// Check right and above
					toY = fromY - (toX - fromX);
					if (toY >= 0) {
						if (board.queenExistsAt(new XYLocation(toX, toY))) {
							nonAttackingPair = false;
						}
					}
					// Check right and below
					toY = fromY + (toX - fromX);
					if (toY < boardSize) {
						if (board.queenExistsAt(new XYLocation(toX, toY))) {
							nonAttackingPair = false;
						}
					}

					if (nonAttackingPair) {
						fitness += 1.0;
					}
				}
			}

			return fitness;
		}
	}

	public static class CfiGenAlgoGoalTest implements GoalTest {
		private final CFIGoalTest goalTest = new GoalTest();

		@SuppressWarnings("unchecked")
		public boolean isGoalState(Object state) {
			return goalTest.isGoalState(getBoardForIndividual((Individual<Integer>) state));
		}
	}

	public static NQueensBoard getBoardForIndividual(Individual<Integer> individual) {
		int boardSize = individual.length();
		NQueensBoard board = new NQueensBoard(boardSize);
		for (int i = 0; i < boardSize; i++) {
			int pos = individual.getRepresentation().get(i);
			board.addQueenAt(new XYLocation(i, pos));
		}

		return board;
	}
}
