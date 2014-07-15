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

  def moves
    potential_positions = []
    self.MOVES_DELTA.each do |(x,y)|
      potential_positions << [self.position[0] + x, self.position[1] + y]
    end
    potential_positions.select { |(x,y)| (x < 8 && x >= 0) && (y < 8 && y >= 0)}
    #TODO Create logic to check if a piece is occupying position
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

  def initialize(position=[x,y])
    super(position)
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


end

class Knight < SteppingPiece
  MOVES_DELTA = [
    [1,2],
    [1,-2],
    [-1,-2],
    [-1,2],
    [2,1],
    [2,-1],
    [-2,-1],
    [-2,1]
  ]
end

class King < SteppingPiece
  MOVES_DELTA = [
    [0,1],
    [-1,1],
    [1,1],
    [0,-1],
    [1,-1],
    [-1,-1],
    [1,0],
    [-1,0]
  ]
end

class Queen < SlidingPiece
  MOVES_DELTA = [
    [0,1],
    [-1,1],
    [1,1],
    [0,-1],
    [1,-1],
    [-1,-1],
    [1,0],
    [-1,0]
  ]

end

class Rook < SlidingPiece
  MOVES_DELTA = [
    [0,1],
    [0,-1],
    [1,0],
    [-1,0]
  ]
end

class Bishop < SlidingPiece
  MOVES_DELTA = [
    [-1,1],
    [1,1],
    [1,-1],
    [-1,-1]
  ]
end