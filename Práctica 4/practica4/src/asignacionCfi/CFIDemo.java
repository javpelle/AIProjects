package asignacionCfi;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Scanner;
import java.util.Set;

import aima.core.search.framework.problem.GoalTest;
import aima.core.search.local.FitnessFunction;
import aima.core.search.local.GeneticAlgorithm;
import aima.core.search.local.Individual;

public class CFIDemo {

	public static final int TOTAL_TURNS = 16;

	private static int turnsToAssign;

	private static List<List<Integer>> restrictionsList;
	private static List<List<Integer>> preferencesList;
	private static List<String> teachersName;

	private static double mutationProbability = 0.05;
	private static double reproductionProbability;

	public static void main(String args[]) {
		readData();
		CFIGeneticAlgorithmSearch();
	}

	public static void CFIGeneticAlgorithmSearch() {
		CFIGenAlgoUtil utils = new CFIGenAlgoUtil();
		FitnessFunction<Integer> fitnessFunction = utils.getFitnessFunction(
				turnsToAssign, restrictionsList, preferencesList);
		GoalTest goalTest = utils.getGoalTest(turnsToAssign, restrictionsList,
				preferencesList);
		// Generate a population
		Set<Individual<Integer>> population = new HashSet<Individual<Integer>>();
		for (int i = 0; i < 50; ++i) {
			Individual<Integer> individual = utils.generateRandomIndividual(
					turnsToAssign, restrictionsList);
			if (individual == null) {
				System.out.println("-----INFEASIBLE!!!-----");
				return;
			}
			population.add(individual);
		}
		GeneticAlgorithm<Integer> g = new GeneticAlgorithm<Integer>(
				TOTAL_TURNS, utils.getFiniteAlphabetForSize(restrictionsList.size()),
				mutationProbability);

		/* Run for a ser amount of time (1 second) */
		Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
				fitnessFunction, goalTest, 1000L);

		printData(bestIndividual, fitnessFunction, goalTest,
				g.getPopulationSize(), g.getIterations(),
				g.getTimeInMilliseconds());
	}

	private static void printData(Individual<Integer> bestIndividual,
			FitnessFunction<Integer> fitnessFunction, GoalTest goalTest,
			int population, int iterations, long time) {

		System.out.println("The final turns assignation is:");

		for (int i = 0; i < bestIndividual.getRepresentation().size(); i++) {
			int numTurn = i + 1;
			if (bestIndividual.getRepresentation().get(i) != 0) {
				System.out.println("Turn " + numTurn + "Professor "
						+ bestIndividual.getRepresentation().get(i));
			} else {
				System.out.println("Turn " + numTurn + "No Professor");
			}
		}

		System.out.println("Turns           = " + turnsToAssign);
		System.out.println("Fitness         = "
				+ fitnessFunction.apply(bestIndividual));
		System.out.println("Is Goal         = "
				+ goalTest.isGoalState(bestIndividual));
		System.out.println("Population Size = " + population);
		System.out.println("Iterations      = " + iterations);
		System.out.println("Took            = " + time + "ms.");
	}

	/* Gets the data from the standard input */
	private static void readData() {
		Scanner s = new Scanner(System.in);

		turnsToAssign = s.nextInt();

		teachersName = new ArrayList<String>(Arrays.asList(readTeachers(s)));

		restrictionsList = new ArrayList<List<Integer>>();
		preferencesList = new ArrayList<List<Integer>>();

		readNumberOfRestrictionsAndPreferences(s, restrictionsList);
		readNumberOfRestrictionsAndPreferences(s, preferencesList);

		s.close();
	}

	private static void readNumberOfRestrictionsAndPreferences(Scanner s,
			List<List<Integer>> list) {
		String line;
		String[] turns;
		for (int i = 0; i < teachersName.size(); ++i) {
			line = s.nextLine();
			if (line.length() == teachersName.get(i).length() + 1) {
				// No restriction or preference
				list.add(new ArrayList<Integer>());
			} else {
				// Some restriction or preference
				line = line.substring(teachersName.get(i).length() + 2);
				turns = line.split(",");
				List<Integer> subList = new ArrayList<Integer>(turns.length);
				list.add(subList);
				for (int j = 0; j < turns.length; ++j) {
					list.get(i).add((Integer.parseInt(turns[j])));
				}
			}
		}
	}

	private static String[] readTeachers(Scanner s) {
		s.nextLine();
		String line;
		String[] teachers;
		line = s.nextLine();
		teachers = line.split(", ");
		return teachers;
	}

}