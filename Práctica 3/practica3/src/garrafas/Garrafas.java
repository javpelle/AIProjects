package garrafas;

import aima.core.agent.Action;
import aima.core.agent.impl.DynamicAction;

public class Garrafas {

	public static Action LLENAR1 = new DynamicAction("Llenar 1");

	public static Action LLENAR2 = new DynamicAction("Llenar 2");

	public static Action VACIAR1 = new DynamicAction("Vaciar 1");

	public static Action VACIAR2 = new DynamicAction("Vaciar 2");

	public static Action VOLCAR1_2 = new DynamicAction("Volcar 1 a 2");

	public static Action VOLCAR2_1 = new DynamicAction("Volcar 2 a 1");

	private static int garrafaTotal1;

	private static int garrafaTotal2;
	
	private static int objetivo;

	private int[] state;

	//
	// PUBLIC METHODS
	//

	public Garrafas() {
		garrafaTotal1 = 5;
		garrafaTotal2 = 3;
		state = new int[] { 0, 0 };
	}

	public Garrafas(int total1, int total2, int litros) {
		garrafaTotal1 = total1;
		garrafaTotal2 = total2;
		objetivo = litros;
		state = new int[] { 0, 0 };
	}

	public Garrafas(int[] state) {
		this.state = new int[state.length];
		System.arraycopy(state, 0, this.state, 0, state.length);
	}

	public Garrafas(Garrafas copia) {
		this(copia.getState());
	}

	public int[] getState() {
		return state;
	}

	public void llenar1() {
		state[0] = garrafaTotal1;
	}

	public void llenar2() {
		state[1] = garrafaTotal2;
	}

	public void vaciar1() {
		state[0] = 0;
	}

	public void vaciar2() {
		state[1] = 0;
	}

	public void volcar1En2() {
		if (state[0] + state[1] <= garrafaTotal2) {
			state[1] += state[0];
			state[0] = 0;
		} else { // desbordamiento
			state[0] = garrafaTotal2 - state[1];
			state[1] = garrafaTotal2;
		}
	}

	public void volcar2En1() {
		if (state[0] + state[1] <= garrafaTotal1) {
			state[0] += state[1];
			state[1] = 0;
		} else { // desbordamiento
			state[1] = garrafaTotal1 - state[0];
			state[0] = garrafaTotal1;
		}
	}

	public boolean canOperate(Action where) {
		if (where.equals(LLENAR1))
			return garrafaTotal1 != state[0];
		else if (where.equals(LLENAR2))
			return garrafaTotal2 != state[1];
		else if (where.equals(VACIAR1))
			return 0 != state[0];
		else if (where.equals(VACIAR2))
			return 0 != state[1];
		else if (where.equals(VOLCAR1_2))
			return state[0] != 0 && garrafaTotal2 != state[1];
		else
			return state[1] != 0 && garrafaTotal1 != state[0];
	}

	@Override
	public boolean equals(Object o) {

		if (this == o) {
			return true;
		}
		if ((o == null) || (this.getClass() != o.getClass())) {
			return false;
		}
		Garrafas aBoard = (Garrafas) o;
		return state[0] == aBoard.getGarrafa1()
				&& state[1] == aBoard.getGarrafa2();
	}

	@Override
	public int hashCode() {
		int result = 17;
		result = 37 * result + state[0];
		result = 37 * result + state[1];
		return result;
	}

	@Override
	public String toString() {
		return "Garrafa 1: " + state[0] + "/" + garrafaTotal1 + "\n"
				+ "Garrafa 2: " + state[1] + "/" + garrafaTotal2 + "\n";
	}

	public int getGarrafa1() {
		return state[0];
	}

	public int getGarrafa2() {
		return state[1];
	}
	
	public int getObjetivo() {
		return objetivo;
	}

	/**
	 * public int getGarrafaTotal1() { return garrafaTotal1; }
	 * 
	 * public int getGarrafaTotal2() { return garrafaTotal2; }
	 **/
}