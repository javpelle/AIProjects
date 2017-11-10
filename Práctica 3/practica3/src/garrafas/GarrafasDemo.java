package garrafas;

import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import aima.core.agent.Action;
import aima.core.search.framework.SearchAgent;
import aima.core.search.framework.SearchForActions;
import aima.core.search.framework.problem.Problem;
import aima.core.search.framework.qsearch.GraphSearch;
import aima.core.search.framework.qsearch.TreeSearch;
import aima.core.search.informed.AStarSearch;
import aima.core.search.informed.GreedyBestFirstSearch;
import aima.core.search.uninformed.BreadthFirstSearch;
import aima.core.search.uninformed.DepthFirstSearch;
import aima.core.search.uninformed.UniformCostSearch;

public class GarrafasDemo {
	static Garrafas garrafasDefault = new Garrafas(12, 3, 1);

	public static void main(String[] args) {
		// B�squeda en anchura con TreeSearch
		garrafasAnchuraTreeSearchDemo();
		// B�squeda en anchura con GraphSearch
		garrafasAnchuraGraphSearchDemo();
		// B�squeda en profundidad con GraphSearch
		garrafasProfundidadGraphSearchDemo();
		// B�squeda de coste unifrome con TreeSearch
		garrafasCosteUniformeTreeSearch();
		// B�squeda de coste unifrome con GraphSearch
		garrafasCosteUniformeGraphSearch();
		// M�todo voraz con GraphSearch
		garrafasVorazGraphSearchDemo();
		// B�squeda en A estrella con TreeSearch
		garrafasAEstrellaTreeSearch();
		// B�squeda en A estrella con GraphSearch
		garrafasAEstrellaGraphSearch();
	}

	private static void garrafasAnchuraTreeSearchDemo() {
		System.out
				.println("\nGarrafasDemo B�squeda en anchura (TreeSearch) -->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new BreadthFirstSearch(new TreeSearch());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void garrafasAnchuraGraphSearchDemo() {
		System.out
				.println("\nGarrafasDemo B�squeda en anchura (GraphSearch) -->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new BreadthFirstSearch(new GraphSearch());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private static void garrafasProfundidadGraphSearchDemo() {
		System.out
				.println("\nGarrafasDemo B�squeda en profundidad (GraphSearch) -->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new DepthFirstSearch(new GraphSearch());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void garrafasCosteUniformeTreeSearch() {
		System.out
				.println("\nGarrafasDemo B�squeda de Coste Uniforme (TreeSearch) -->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new UniformCostSearch(new TreeSearch());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void garrafasCosteUniformeGraphSearch() {
		System.out
				.println("\nGarrafasDemo B�squeda de Coste Uniforme (GraphSearch) -->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new UniformCostSearch(new GraphSearch());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void garrafasVorazGraphSearchDemo() {
		System.out.println("\nGarrafasDemo M�todo voraz (GraphSearch)-->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new GreedyBestFirstSearch(
					new GraphSearch(), new GarrafasHeuristicFunction());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private static void garrafasAEstrellaTreeSearch() {
		System.out
				.println("\nGarrafasDemo B�squeda A estrella (TreeSearch)-->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new AStarSearch(new TreeSearch(),
					new GarrafasHeuristicFunction());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void garrafasAEstrellaGraphSearch() {
		System.out
				.println("\nGarrafasDemo B�squeda A estrella (GraphSearch)-->");
		try {
			Problem problem = new Problem(garrafasDefault,
					GarrafasFunctionFactory.getActionsFunction(),
					GarrafasFunctionFactory.getResultFunction(),
					new GarrafasGoalTest());
			SearchForActions search = new AStarSearch(new GraphSearch(),
					new GarrafasHeuristicFunction());
			long timeStart, timeEnd;
			timeStart = System.nanoTime();
			SearchAgent agent = new SearchAgent(problem, search);
			timeEnd = System.nanoTime();
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation(), timeEnd - timeStart);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void printInstrumentation(Properties properties, long time) {
		Iterator<Object> keys = properties.keySet().iterator();
		while (keys.hasNext()) {
			String key = (String) keys.next();
			String property = properties.getProperty(key);
			System.out.println(key + " : " + property);
		}
		System.out.println("Execution time: " + time + " nanoseconds.");

	}

	private static void printActions(List<Action> actions) {
		for (int i = 0; i < actions.size(); i++) {
			String action = actions.get(i).toString();
			System.out.println(action);
		}
	}
}
