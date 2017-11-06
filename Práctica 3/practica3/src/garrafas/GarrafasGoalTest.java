package garrafas;

import aima.core.search.framework.problem.GoalTest;

public class GarrafasGoalTest implements GoalTest {

	@Override
	public boolean isGoalState(Object state) {
		Garrafas o = (Garrafas)state;
		return o.getGarrafa1() == o.getObjetivo() || o.getGarrafa2() == o.getObjetivo();
	}

}