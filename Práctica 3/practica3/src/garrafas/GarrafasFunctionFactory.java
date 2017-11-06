package garrafas;

import java.util.LinkedHashSet;
import java.util.Set;

import aima.core.agent.Action;
import aima.core.search.framework.problem.ActionsFunction;
import aima.core.search.framework.problem.ResultFunction;

public class GarrafasFunctionFactory {
	private static ActionsFunction _actionsFunction = null;
	private static ResultFunction _resultFunction = null;

	public static ActionsFunction getActionsFunction() {
		if (null == _actionsFunction) {
			_actionsFunction = new GarrafasActionsFunction();
		}
		return _actionsFunction;
	}

	public static ResultFunction getResultFunction() {
		if (null == _resultFunction) {
			_resultFunction = new GarrafasResultFunction();
		}
		return _resultFunction;
	}

	private static class GarrafasActionsFunction implements ActionsFunction {
		public Set<Action> actions(Object state) {
			Garrafas estadoActual = (Garrafas) state;

			Set<Action> actions = new LinkedHashSet<Action>();

			if (estadoActual.canOperate(Garrafas.LLENAR1)) {
				actions.add(Garrafas.LLENAR1);
			}
			if (estadoActual.canOperate(Garrafas.LLENAR2)) {
				actions.add(Garrafas.LLENAR2);
			}
			if (estadoActual.canOperate(Garrafas.VACIAR1)) {
				actions.add(Garrafas.VACIAR1);
			}
			if (estadoActual.canOperate(Garrafas.VACIAR2)) {
				actions.add(Garrafas.VACIAR2);
			}
			if (estadoActual.canOperate(Garrafas.VOLCAR1_2)) {
				actions.add(Garrafas.VOLCAR1_2);
			}
			if (estadoActual.canOperate(Garrafas.VOLCAR2_1)) {
				actions.add(Garrafas.VOLCAR2_1);
			}

			return actions;
		}
	}

	private static class GarrafasResultFunction implements ResultFunction {
		public Object result(Object s, Action a) {
			Garrafas estadoActual = (Garrafas) s;

			if (Garrafas.LLENAR1.equals(a)
					&& estadoActual.canOperate(Garrafas.LLENAR1)) {
				Garrafas newBoard = new Garrafas(estadoActual);
				newBoard.llenar1();
				return newBoard;
			} else if (Garrafas.LLENAR2.equals(a)
					&& estadoActual.canOperate(Garrafas.LLENAR2)) {
				Garrafas newBoard = new Garrafas(estadoActual);
				newBoard.llenar2();
				return newBoard;
			} else if (Garrafas.VACIAR1.equals(a)
					&& estadoActual.canOperate(Garrafas.VACIAR1)) {
				Garrafas newBoard = new Garrafas(estadoActual);
				newBoard.vaciar1();
				return newBoard;
			} else if (Garrafas.VACIAR2.equals(a)
					&& estadoActual.canOperate(Garrafas.VACIAR2)) {
				Garrafas newBoard = new Garrafas(estadoActual);
				newBoard.vaciar2();
				return newBoard;
			} else if (Garrafas.VOLCAR1_2.equals(a)
					&& estadoActual.canOperate(Garrafas.VOLCAR1_2)) {
				Garrafas newBoard = new Garrafas(estadoActual);
				newBoard.volcar1En2();
				return newBoard;
			} else if (Garrafas.VOLCAR2_1.equals(a)
					&& estadoActual.canOperate(Garrafas.VOLCAR2_1)) {
				Garrafas newBoard = new Garrafas(estadoActual);
				newBoard.volcar2En1();
				return newBoard;
			}

			return s;
		}
	}
}
