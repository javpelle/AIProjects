package cfi;

import aima.core.search.framework.problem.GoalTest;

public class CfiGoalTest {

	public boolean isGoalState(Object state) {
		NQueensBoard board = (NQueensBoard) state;
		return board.getNumberOfQueensOnBoard() == board.getSize()
				&& board.getNumberOfAttackingPairs() == 0;
	}
}
