# coding: UTF-8

class Board
  attr_accessor :board

  ROOK_POS = [
    [7,7],[0,0],
    [0,7],[7,0]
  ]

  KNIGHT_POS = [
    [1,0],[6,0],
    [1,7],[6,7]
  ]

  BISHOP_POS = [
    [2,0],[5,0],
    [2,7],[5,7]
  ]

  PAWN_POS = [
    [0,1],[0,6],
    [1,1],[1,6],
    [2,1],[2,6],
    [3,1],[3,6],
    [4,1],[4,6],
    [5,1],[5,6],
    [6,1],[6,6],
    [7,1],[7,6]
  ]

  QUEEN_POS = [[3,0],[3,7]]
  KING_POS = [[4,0],[4,7]]

  def initialize
    @board = Array.new(8){Array.new(8)}
    self.place_pieces
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def render
    print "\n\n"
    @board.each do |row|
      print "\t\t"
      row.each do |obj|
       if obj.nil?
         print "| "
       else
         print obj.display
       end
     end
     print "|"
     print "\n"
    end
    nil
  end

  def place_pieces
    BISHOP_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @board[y][x] = Bishop.new(self, [x,y], color)
    end
    ROOK_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @board[y][x] = Rook.new(self, [x,y], color)
    end
    KING_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @board[y][x] = King.new(self, [x,y], color)
    end
    QUEEN_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @board[y][x] = Queen.new(self, [x,y], color)
    end
    KNIGHT_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @board[y][x] = Knight.new(self, [x,y], color)
    end
    PAWN_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @board[y][x] = Pawn.new(self, [x,y], color)
    end
    nil
  end
end

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @board.render
  end

  def make_move
  end


end

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
    self.MOVES_DELTA.each do |(x, y)|
      next if on_the_board?(x,y) || @board[x,y].color == self.color
      potential_positions << [self.position[0] + x, self.position[1] + y]
    end
    potential_postions
    #TODO Create logic to check if a piece is occupying position
  end

  def on_the_board?(x,y)
    self.position[0] + x <= 7 && self.position[1] + y <= 7 && self.position[0] + x >= 0 && self.position[1] + y >= 0
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
  MOVES_DELTA = [
    [0,1],
    [0,2],
    [-1,1],
    [1,1],
    [0,-1],
    [0,-2],
    [1,-1],
    [-1,-1]]

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



