#-------------------------
#  Pieces Code
#-------------------------

class Piece

  attr_accessor :position, :color

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
    @previous_positions = [] #shovel in whenever a move happens
  end

  def moves
    potential_positions = []
    self.send_moves.each do |(x, y)|
      p " #{x}, #{y}"
      p self.position
      p @board[[x,y]]
      #p @board[[x,y]].color != self.color
      p on_the_board?(self.position[0] + x, self.position[1] + y)
      if (@board[[x,y]].nil? || @board[[x,y]].color != self.color) &&
         on_the_board?(self.position[0] + x, self.position[1] + y)
        potential_positions << [self.position[0] + x, self.position[1] + y]
      else
        next
      end
    end
    p potential_positions
  end

  def on_the_board?(x,y)
     x <= 7 &&  y <= 7 &&  x >= 0 && y >= 0
  end
end

class SlidingPiece < Piece


  def moves
    potential_positions = []
    self.MOVES_DELTA.each do |(x, y)|
      d_x, d_y = x, y
      while on_the_board?(d_x, d_y)
        if @board[d_x,d_y].nil?
          potential_positions << [self.position[0] + d_x,
                                  self.position[1] + d_y]
          d_x, d_y = (d_x + x), (d_y + y)
        elsif @board[d_x,d_y].color == self.color
          break
        else
          potential_positions << [self.position[0] + d_x,
                                  self.position[1] + d_y]
          d_x, d_y = (d_x + x), (d_y + y)
          break
        end
      end
    end
    potential_postions
    #TODO Create logic to check if a piece is occupying position
  end




end

class SteppingPiece < Piece


end

class Pawn < Piece

  MOVES_DELTA_W = [
    [0,-1]
  ]

  MOVES_DELTA_B = [
    [0,1]
  ]

  ATTACK_DELTA_W = [
    [-1,-1],[1,-1]
  ]

  ATTACK_DELTA_B = [
    [1,1],[-1,1]
  ]

  FIRST_DELTA_B = [
    [0,2],[0,1]
  ]

  FIRST_DELTA_W = [
    [0,-2],[0,-1]
  ]

  def moves
    potential_positions = []
    self.send_moves.each do |(x, y)|
      p " #{x}, #{y}"
      p self.position
      if (@board[[x,y]].nil? || @board[[x,y]].color != self.color) && on_the_board?(x,y)
        potential_positions << [self.position[0] + x, self.position[1] + y]
      else
        next
      end
    end
    p potential_positions
  end

  def on_the_board?(x,y)
    self.position[0] + x <= 7 && self.position[1] + y <= 7 && self.position[0] + x >= 0 && self.position[1] + y >= 0
  end
  def display
    @color == :white ? "|♙" : "|♟"
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

  def send_moves
    MOVES_DELTA
  end

  def display
    @color == :white ? "|♘" : "|♞"
  end
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

  def display
    @color == :white ? "|♔" : "|♚"
  end
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

  def display
    @color == :white ? "|♕" : "|♛"
  end

end

class Rook < SlidingPiece
  MOVES_DELTA = [
    [0,1],
    [0,-1],
    [1,0],
    [-1,0]
  ]

  def display
    @color == :white ? "|♖" : "|♜"
  end
end

class Bishop < SlidingPiece
  MOVES_DELTA = [
    [-1,1],
    [1,1],
    [1,-1],
    [-1,-1]
  ]

  def display
    @color == :white ? "|♗" : "|♝"
  end
end
