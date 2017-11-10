package garrafas;

import aima.core.search.framework.evalfunc.HeuristicFunction;

public class GarrafasHeuristicFunction implements HeuristicFunction {

	@Override
	public double h(Object state) {
		Garrafas estadoActual = (Garrafas) state;
		int agua1 = estadoActual.getGarrafa1();
		int agua2 = estadoActual.getGarrafa2();
		if ((agua1 - estadoActual.getObjetivo()) == 0
				|| (agua2 - estadoActual.getObjetivo()) == 0) {
			return 0;
		} else if (objetivoVaciar1en2(estadoActual)
				|| objetivoVaciar2en1(estadoActual)) {
			return 1;
		} else {
			return 2;
		}

	}

	private boolean objetivoVaciar1en2(Garrafas estadoActual) {
		if (estadoActual.getGarrafa1() + estadoActual.getGarrafa2() <= estadoActual
				.getGarrafaTotal2()) {
			return estadoActual.getGarrafa1() + estadoActual.getGarrafa2() == estadoActual
					.getObjetivo();
		} else { // desbordamiento
			return estadoActual.getGarrafa1() + estadoActual.getGarrafa2()
					- estadoActual.getGarrafaTotal2() == estadoActual
						.getObjetivo();
		}
	}

	private boolean objetivoVaciar2en1(Garrafas estadoActual) {
		if (estadoActual.getGarrafa1() + estadoActual.getGarrafa2() <= estadoActual
				.getGarrafaTotal1()) {
			return estadoActual.getGarrafa1() + estadoActual.getGarrafa2() == estadoActual
					.getObjetivo();
		} else { // desbordamiento
			return estadoActual.getGarrafa1() + estadoActual.getGarrafa2()
					- estadoActual.getGarrafaTotal1() == estadoActual
						.getObjetivo();
		}
	}
}
