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

class BadMove < StandardMove
end

class Game
  attr_reader :board

  def initialize(white_player, black_player)
    @white_player, @black_player = white_player, black_player
    @white_player.color, @black_player.color = :white, :black
    @board = Board.new
    play
  end

  def play
    player = [@white_player, @black_player]
    while !checkmate
      begin
        @board.render
        piece = @board[player[0].select_piece]
        raise BadOwnership if !piece ==
        end_point = player[0].make_move
        raise BadMove if !confirm_move(end_point))
        player.rotate![1]
      rescue BadMove
        puts "You can not move there"
        retry
      rescue BadOwnership
        puts "You do not have a piece in that location"
        retry
      end
    end
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

#-------------------------
#  Player Code
#-------------------------
class IllegalCoordinatesError < StandardError
end


class Player


  #TODO FIX CONVERSION
  COL_CONVERT = {
   "A" => 1,
   "B" => 2,
   "C" => 3,
   "D" => 4,
   "E" => 5,
   "F" => 6,
   "G" => 7,
   "H" => 8
  }

  attr_accessor :color

  def initialize
    @color = nil
  end


  def legal_move(pos)
    if pos.length > 2
      raise IllegalCoordinatesError
    elsif (Integer(pos[1]) < 1) || (Integer(pos[1]) > 8)
      raise IllegalCoordinatesError
    elsif COL_CONVERT[pos[0]].nil?
      raise IllegalCoordinatesError
    end
    nil
  end

  def make_move
    begin
      puts "Provide coordinates of piece to move (Col: A-H, Row: 1-8)"
      start_point = gets.chomp.split("")
      legal_move(start_point)
      confirm_ownership(start_point)

      puts "Provide coordinates of destination (Col: A-H, Row: 1-8)"
      end_point = gets.chomp.split("")
      legal_move(end_point)
      confirm_move(start_move, end_point)

      move_pos = [start_point , end_point]

    rescue IllegalCoordinatesError
      puts "Illegal coordinates provided"
      retry

    rescue ArgumentError
      puts "Illegal coordinates provided"
      retry
    end

  end

  def confirm_ownership(start_point)

  end


end




