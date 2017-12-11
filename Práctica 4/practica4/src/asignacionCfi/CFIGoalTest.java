package asignacionCfi;

import aima.core.search.framework.problem.GoalTest;

public class CFIGoalTest {

	public boolean isGoalState(Object state) {
		NQueensBoard board = (NQueensBoard) state;
		return board.getNumberOfQueensOnBoard() == board.getSize()
				&& board.getNumberOfAttackingPairs() == 0;
	}
}
