class Board

end

#-------------------------
#  Pieces Code
#-------------------------

class Piece

  attr_accessor :position

  def initialize(position)
    @position = position
  end


  def moves(possible_moves=[])

  end

end

class SlidingPiece < Piece

  def initialize(position)
    super(position)
  end

  def moves

  end

end

class SteppingPiece < Piece

  def initialize(position)
    super(position)
  end

  def moves

  end

end

class Pawn < Piece
  MOVES_DELTA = [
    [0,1],
    [0,2],
    [-1,1],
    [1,1],
    [0,-1],
    [0,-2],
    [1,-1],
    [-1,-1]]

  def initialize(position)
    super(position)
  end

  def moves

  end

end

class Knight < SteppingPiece

end

class King < SteppingPiece

end

class Queen < SlidingPiece

  def moves
    DIRECTIONS = [[1,0], [2,0], [3,0], [1,1], [2,2]]


  end

end

class Rook < SlidingPiece

end

class Bishop < SlidingPiece

end