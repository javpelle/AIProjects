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

	private static double mutationProbability = 0.15;

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

		double[] maxFitness = new double[6];
		double[] mediaFitness = new double[6];
		long[] minTime = new long[6];
		long[] mediaTime = new long[6];
		for (int i = 0; i < 6; ++i) {
			maxFitness[i] = 0;
			mediaFitness[i] = 0;
			minTime[i] = 99999;
			mediaTime[i] = 0;
		}
		Set<Individual<Integer>> population = null;
		// Standard Algorithm
		for (int iterations = 0; iterations < 100; ++iterations) {
			population = createPopulation(utils);
			GeneticAlgorithm<Integer> g = new CFIGeneticAlgorithm(TOTAL_TURNS,
					utils.getFiniteAlphabetForSize(restrictionsList.size()),
					mutationProbability, turnsToAssign, restrictionsList);
			Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
					fitnessFunction, goalTest, 500L);
			double fit = fitnessFunction.apply(bestIndividual);
			if (fit > maxFitness[0]) {
				maxFitness[0] = fit;
			}
			if (g.getTimeInMilliseconds() < minTime[0]) {
				minTime[0] = g.getTimeInMilliseconds();
			}
			mediaFitness[0] += fit;
			mediaTime[0] += g.getTimeInMilliseconds();
		}
		mediaFitness[0] /= 100.0;
		mediaTime[0] /= 100;

		// Algorithm with reproduce probability 0.7
		for (int iterations = 0; iterations < 100; ++iterations) {
			population = createPopulation(utils);
			GeneticAlgorithm<Integer> g = new CFIGeneticAlgorithmProb(
					TOTAL_TURNS,
					utils.getFiniteAlphabetForSize(restrictionsList.size()),
					mutationProbability, turnsToAssign, restrictionsList, 0.7);
			Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
					fitnessFunction, goalTest, 500L);
			double fit = fitnessFunction.apply(bestIndividual);
			if (fit > maxFitness[1]) {
				maxFitness[1] = fit;
			}
			if (g.getTimeInMilliseconds() < minTime[1]) {
				minTime[1] = g.getTimeInMilliseconds();
			}
			mediaFitness[1] += fit;
			mediaTime[1] += g.getTimeInMilliseconds();
		}
		mediaFitness[1] /= 100.0;
		mediaTime[1] /= 100;

		// Algorithm with reproduce probability 0.8
		for (int iterations = 0; iterations < 100; ++iterations) {
			population = createPopulation(utils);
			GeneticAlgorithm<Integer> g = new CFIGeneticAlgorithmProb(
					TOTAL_TURNS,
					utils.getFiniteAlphabetForSize(restrictionsList.size()),
					mutationProbability, turnsToAssign, restrictionsList, 0.8);
			Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
					fitnessFunction, goalTest, 500L);
			double fit = fitnessFunction.apply(bestIndividual);
			if (fit > maxFitness[2]) {
				maxFitness[2] = fit;
			}
			if (g.getTimeInMilliseconds() < minTime[2]) {
				minTime[2] = g.getTimeInMilliseconds();
			}
			mediaFitness[2] += fit;
			mediaTime[2] += g.getTimeInMilliseconds();
		}
		mediaFitness[2] /= 100.0;
		mediaTime[2] /= 100;

		// Algorithm with reproduce probability 0.9
		for (int iterations = 0; iterations < 100; ++iterations) {
			population = createPopulation(utils);
			GeneticAlgorithm<Integer> g = new CFIGeneticAlgorithmProb(
					TOTAL_TURNS,
					utils.getFiniteAlphabetForSize(restrictionsList.size()),
					mutationProbability, turnsToAssign, restrictionsList, 0.9);
			Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
					fitnessFunction, goalTest, 500L);
			double fit = fitnessFunction.apply(bestIndividual);
			if (fit > maxFitness[3]) {
				maxFitness[3] = fit;
			}
			if (g.getTimeInMilliseconds() < minTime[3]) {
				minTime[3] = g.getTimeInMilliseconds();
			}
			mediaFitness[3] += fit;
			mediaTime[3] += g.getTimeInMilliseconds();
		}
		mediaFitness[3] /= 100.0;
		mediaTime[3] /= 100;

		// Algorithm with two children and reproduce probability 0.8
		for (int iterations = 0; iterations < 100; ++iterations) {
			population = createPopulation(utils);
			GeneticAlgorithm<Integer> g = new CFIGeneticAlgorithmTwoChildren(
					TOTAL_TURNS,
					utils.getFiniteAlphabetForSize(restrictionsList.size()),
					mutationProbability, turnsToAssign, restrictionsList, 0.8);
			Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
					fitnessFunction, goalTest, 500L);
			double fit = fitnessFunction.apply(bestIndividual);
			if (fit > maxFitness[4]) {
				maxFitness[4] = fit;
			}
			if (g.getTimeInMilliseconds() < minTime[4]) {
				minTime[4] = g.getTimeInMilliseconds();
			}
			mediaFitness[4] += fit;
			mediaTime[4] += g.getTimeInMilliseconds();
		}
		mediaFitness[4] /= 100.0;
		mediaTime[4] /= 100;

		// Algorithm with no destruction, two children and reproduce probability
		// 0.8
		for (int iterations = 0; iterations < 100; ++iterations) {
			population = createPopulation(utils);
			GeneticAlgorithm<Integer> g = new CFIGeneticAlgorithmNoDest(
					TOTAL_TURNS,
					utils.getFiniteAlphabetForSize(restrictionsList.size()),
					mutationProbability, turnsToAssign, restrictionsList, 0.8);
			Individual<Integer> bestIndividual = g.geneticAlgorithm(population,
					fitnessFunction, goalTest, 500L);
			double fit = fitnessFunction.apply(bestIndividual);
			if (fit > maxFitness[5]) {
				maxFitness[5] = fit;
			}
			if (g.getTimeInMilliseconds() < minTime[5]) {
				minTime[5] = g.getTimeInMilliseconds();
			}
			mediaFitness[5] += fit;
			mediaTime[5] += g.getTimeInMilliseconds();
		}
		mediaFitness[5] /= 100.0;
		mediaTime[5] /= 100;

		printData(maxFitness, mediaFitness, minTime, mediaTime);
	}

	private static void printData(double[] maxFitness, double[] mediaFitness,
			long[] minTime, long[] mediaTime) {

		System.out.println("--Standard algorithm--");
		System.out.println("Max. fitness: " + maxFitness[0]);
		System.out.println("Media fitness: " + mediaFitness[0]);
		System.out.println("Min. Time: " + minTime[0]);
		System.out.println("Media Time: " + mediaTime[0]);

		System.out.println();

		System.out.println("--Algorithm with reproduce probability 0.7--");
		System.out.println("Max. fitness: " + maxFitness[1]);
		System.out.println("Media fitness: " + mediaFitness[1]);
		System.out.println("Min. Time: " + minTime[1]);
		System.out.println("Media Time: " + mediaTime[1]);

		System.out.println();

		System.out.println("--Algorithm with reproduce probability 0.8--");
		System.out.println("Max. fitness: " + maxFitness[2]);
		System.out.println("Media fitness: " + mediaFitness[2]);
		System.out.println("Min. Time: " + minTime[2]);
		System.out.println("Media Time: " + mediaTime[2]);

		System.out.println();

		System.out.println("--Algorithm with reproduce probability 0.9--");
		System.out.println("Max. fitness: " + maxFitness[3]);
		System.out.println("Media fitness: " + mediaFitness[3]);
		System.out.println("Min. Time: " + minTime[3]);
		System.out.println("Media Time: " + mediaTime[3]);

		System.out.println();
		
		System.out
				.println("--Algorithm with two children and reproduce probability 0.8--");
		System.out.println("Max. fitness: " + maxFitness[4]);
		System.out.println("Media fitness: " + mediaFitness[4]);
		System.out.println("Min. Time: " + minTime[4]);
		System.out.println("Media Time: " + mediaTime[4]);

		System.out.println();
		
		System.out
				.println("--Algorithm with no destruction, two children and reproduce probability 0.8--");
		System.out.println("Max. fitness: " + maxFitness[5]);
		System.out.println("Media fitness: " + mediaFitness[5]);
		System.out.println("Min. Time: " + minTime[5]);
		System.out.println("Media Time: " + mediaTime[5]);
	}

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
					list.get(i).add((Integer.parseInt(turns[j])) - 1);
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

	private static HashSet<Individual<Integer>> createPopulation(CFIGenAlgoUtil utils) {
		HashSet<Individual<Integer>> population = new HashSet<Individual<Integer>>();
		for (int i = 0; i < 50; ++i) {
			Individual<Integer> individual = utils.generateRandomIndividual(
					turnsToAssign, restrictionsList);
			if (individual == null) {
				System.out.println("No solution");
				return null;
			}
			population.add(individual);
		}
		return population;
	}
}