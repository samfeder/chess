class Board

end

#-------------------------
#  Pieces Code
#-------------------------

class Piece

  attr_accessor :position

  def initialize(position)
    @position = position
    @previous_positions = [] #shovel in whenever a move happens
  end

  def moves
    potential_positions = []
    self.MOVES_DELTA.each do |(x,y)|
      if on_the_board?(x,y)
        potential_positions << [self.position[0] + x, self.position[1] + y]
      end
    end
    potential_positions
    #TODO Create logic to check if a piece is occupying position
  end

  def on_the_board?(x,y)
    self.position[0] + x <= 7 && self.position[1] + y <= 7 && self.position[0] + x >= 0 && self.position[1] + y >= 0
  end
end

class SlidingPiece < Piece

  def initialize(position)
    super(position)
  end

  def moves
    potential_positions = []
    self.MOVES_DELTA.each do |(x, y)|
      d_x, d_y = x, y
      while on_the_board?(d_x, d_y)
        potential_positions << [self.position[0] + d_x, self.position[1] + d_y]
        d_x, d_y = (d_x + x), (d_y + y)
      end
    end
    potential_postions
    #TODO Create logic to check if a piece is occupying position
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