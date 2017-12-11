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

	private static int turnsNumber;

	private static List<List<Integer>> restrictionsList;
	private static List<List<Integer>> preferencesList;
	private static List<String> teachersName;

	private static int mutationProbability;
	private static int reproductionProbability;

	public static void main(String args[]) {
		readData();
		CFIGeneticAlgorithmSearch();
	}

	public static void CFIGeneticAlgorithmSearch() {
		FitnessFunction<Integer> fitnessFunction = new ExamTurnsFitnessFunction(
				turns, restrictions, preferences);
		GoalTest goalTest = new ExamTurnsGoalTest(turns, restrictions,
				preferences);
		/* Generate an initial population */
		Set<Individual<Integer>> population = new HashSet<Individual<Integer>>();
		Boolean infeasible = false;
		for (int i = 0; i < 50; i++) {
			population.add(ExamTurnsUtil.generateRandomIndividual(turns,
					professors, restrictions, infeasible));
			if (infeasible) {
				System.out.println("-----INFEASIBLE!!!-----");
				break;
			}
		}

		if (!infeasible) {
			GeneticAlgorithm<Integer> ga = new GeneticAlgorithm<Integer>(
					TOTAL_TURNS, ExamTurnsUtil.getFiniteAlphabet(professors),
					mutationProbability);

			/* Run for a ser amount of time (1 second) */
			Individual<Integer> bestIndividual = ga.geneticAlgorithm(
					population, fitnessFunction, goalTest, 1000L);

			printData(bestIndividual, fitnessFunction, goalTest,
					ga.getPopulationSize(), ga.getIterations(),
					ga.getTimeInMilliseconds());

			/* Run until the goal is achieved */
			bestIndividual = ga.geneticAlgorithm(population, fitnessFunction,
					goalTest, 0L);

			printData(bestIndividual, fitnessFunction, goalTest,
					ga.getPopulationSize(), ga.getIterations(),
					ga.getTimeInMilliseconds());

			ModifiedGeneticAlgorithm1 modGa = new ModifiedGeneticAlgorithm1(
					TOTAL_TURNS, ExamTurnsUtil.getFiniteAlphabet(professors),
					mutationProbability, reproductionProbability);

			/* Run for a set amount of time (1 second) */
			bestIndividual = modGa.geneticAlgorithm(population,
					fitnessFunction, goalTest, 1000L);

			printData(bestIndividual, fitnessFunction, goalTest,
					ga.getPopulationSize(), ga.getIterations(),
					ga.getTimeInMilliseconds());

			/* Run until the goal is achieved */
			bestIndividual = modGa.geneticAlgorithm(population,
					fitnessFunction, goalTest, 1000L);

			printData(bestIndividual, fitnessFunction, goalTest,
					ga.getPopulationSize(), ga.getIterations(),
					ga.getTimeInMilliseconds());
		}
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

		System.out.println("Turns           = " + turnsNumber);
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

		turnsNumber = s.nextInt();

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