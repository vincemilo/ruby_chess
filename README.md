# ruby_chess
Command line chess program written in Ruby. View in [Replit](https://replit.com/@vincemilo/rubychess#.replit) or clone this repository for a faster and more stable version.

Enforces the rules of chess including:

- King cannot move into or ignore check
- Castling is only legal if:
  - King is not in check
  - Neither piece has moved
  - King will not move into check along the path to its destination square
- En passant is only legal immediately following opponent's two-square pawn move
- Checkmate if player to move has no legal moves and their King is in check
- Stalemate if player to move has no legal moves and their King is not in check
- Draw if insufficient material

Features to be added at a later date:

- Algebraic notation movement log and PGN input/output
- Simple AI move database for more challenging games
- Improved graphic display
