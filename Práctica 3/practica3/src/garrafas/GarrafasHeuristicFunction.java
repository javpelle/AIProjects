package garrafas;

import aima.core.search.framework.evalfunc.HeuristicFunction;

public class GarrafasHeuristicFunction implements HeuristicFunction {

	@Override
	public double h(Object state) {
		Garrafas estadoActual = (Garrafas) state;
		int agua1 = estadoActual.getState()[0];
		int agua2 = estadoActual.getState()[1];
		return Math.min(Math.abs(agua1 - estadoActual.getObjetivo()),
				Math.abs(agua2 - estadoActual.getObjetivo()));
	}

}
