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

end

class Rook < SlidingPiece

end

class Bishop < SlidingPiece

end