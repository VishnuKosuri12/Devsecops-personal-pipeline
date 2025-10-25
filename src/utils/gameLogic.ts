/**
 * Situation: A tic-tac-toe board is represented as a linear array.
 * Task: Determine if there is a winner given the current board state.
 * Action: Scan all possible winning line combinations and check if any line is held by the same player.
 * Result: Return the winning symbol and line indices if found; otherwise return null.
 */
export function calculateWinner(squares: Array<string | null>): { winner: string; line: number[] } | null {
  const lines = [
    [0, 1, 2], // top row
    [3, 4, 5], // middle row
    [6, 7, 8], // bottom row
    [0, 3, 6], // left column
    [1, 4, 7], // middle column
    [2, 5, 8], // right column
    [0, 4, 8], // diagonal top-left → bottom-right
    [2, 4, 6], // diagonal top-right → bottom-left
  ];

  for (const [a, b, c] of lines) {
    const sq = squares[a];
    if (sq !== null && sq === squares[b] && sq === squares[c]) {
      return { winner: sq, line: [a, b, c] };
    }
  }

  return null;
}

/**
 * Situation: After each turn in a tic-tac-toe game, the board may be full.
 * Task: Check if the game has ended in a draw.
 * Action: Verify there is no winner, and then check that every square is filled.
 * Result: Return `true` if the game is a draw; otherwise return `false`.
 */
export function checkDraw(squares: Array<string | null>): boolean {
  // If a winner exists, the game is not a draw
  if (calculateWinner(squares) !== null) {
    return false;
  }

  // The game is a draw only if there are no null squares left
  return squares.every(square => square !== null);
}
