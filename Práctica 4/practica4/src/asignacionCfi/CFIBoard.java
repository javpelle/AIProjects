package asignacionCfi;

public class CFIBoard {

	int[] turns;

	int size;

	/**
	 * Creates a board with <code>size</code> turns. Turns indices start with
	 * -1.
	 */
	public CFIBoard(int size) {
		this.size = size;
		turns = new int[size];
		for (int i = 0; i < size; i++) {
			turns[i] = -1;
		}
	}

	/**
	 * public CFIBoard(int size, Config config) { this(size); if (config ==
	 * Config.QUEENS_IN_FIRST_ROW) { for (int i = 0; i < size; i++)
	 * addQueenAt(new XYLocation(i, 0)); } else if (config ==
	 * Config.QUEEN_IN_EVERY_COL) { Random r = new Random(); for (int i = 0; i <
	 * size; i++) addQueenAt(new XYLocation(i, r.nextInt(size))); } }
	 **/

	/**
	 * Remove teachers from turns list.
	 */
	public void clear() {
		for (int i = 0; i < size; i++) {
			turns[i] = -1;
		}
	}
	
	/**
	 * Add a teacher in a turn.
	 * @param turn
	 * @param teacher
	 */
	public void addTeacherAt(int turn, int teacher) {
		if (!(teacherExistsAt(turn)))
			turns[turn] = teacher;
	}
	
	/**
	 * Remove a teacher from a turn
	 * @param turn
	 */
	public void removeTeacherFrom(int turn) {
		turns[turn] = -1;
	}
	
	/**
	 * Move a teacher from a turn to another.
	 * @param from
	 * @param to
	 */
	public void moveTeacher(int from, int to) {
		if ((teacherExistsAt(from)) && (!(teacherExistsAt(to)))) {
			addTeacherAt(to, getTeacherFrom(from));
			removeTeacherFrom(from);
		}
	}
	
	/**
	 * Check if exists a teacher in a turn.
	 * @param i
	 * @return if exists a teacher in turn i
	 */
	private boolean teacherExistsAt(int i) {
		return turns[i] != -1;
	}
	
	/**
	 * @return Number of teachers on board
	 */
	public int getNumberOfTeachersOnBoard() {
		int count = 0;
		for (int i = 0; i < size; i++) {
			if (turns[i] != -1)
				++count;
		}
		return count;
	}
	
	/**
	 * @return Turns size
	 */
	public int getSize() {
		return size;
	}
	
	public int getTeacherFrom(int turn) {
		return turns[turn];
	}

}
