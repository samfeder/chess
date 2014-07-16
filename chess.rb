# coding: UTF-8

require_relative "./pieces.rb"
#require_relative "./board.rb"

class Board
  attr_accessor :grid, :jail

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
    @grid = Array.new(8){Array.new(8)}
    self.place_pieces
    @jail = []
  end

  def [](pos)
    col, row = pos
    @grid[row][col]
  end

  def []=(pos, value)
    col, row = pos
    @grid[row][col] = value
  end

  def in_check?(color)
    attacking_moves = []
    king_pos = []
    @grid.each do |row|
      row.each do |piece|
        next if piece.nil?
        king_pos = piece.position if piece.color == color && piece.is_a?(King)
        next if piece.color == color
        if piece.color != color
          attacking_moves += piece.moves
        end
      end
    end
    attacking_moves.include?(king_pos)
  end


  def render
    print "\n\n"
    @grid.each_with_index do |row,i|
      print "\t\t#{i+1}"
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
    print "\t\t "
    ("A".."H").to_a.each {|letter| print " #{letter}"}
     print "\n"
     print "\n"
    nil
  end

  def place_pieces
    BISHOP_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @grid[y][x] = Bishop.new(self, [x,y], color)
    end
    ROOK_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @grid[y][x] = Rook.new(self, [x,y], color)
    end
    KING_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @grid[y][x] = King.new(self, [x,y], color)
    end
    QUEEN_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @grid[y][x] = Queen.new(self, [x,y], color)
    end
    KNIGHT_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @grid[y][x] = Knight.new(self, [x,y], color)
    end
    PAWN_POS.each do |(x,y)|
      color = y < 4 ? :white : :black
      @grid[y][x] = Pawn.new(self, [x,y], color)
    end
    nil
  end
end

#-------------------------
#  GAME Code
#-------------------------

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
    while !checkmate?
      begin
        @board.render
        if @board.in_check?(player[0].color)
          puts "#{player[0].upcase} IS IN CHECK!!!!"
        piece_pos = (player[0].select_piece)
        piece_obj = @board[piece_pos]
        p "#{piece_obj.class} moves: #{piece_obj.moves}"
        raise BadOwnership if (piece_obj.color != player[0].color) || piece_obj.nil?

        end_pos = player[0].find_move
        raise BadMove if !piece_obj.moves.include?(end_pos)

        make_move(piece_pos, end_pos, player)

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

  def checkmate?
    false #TODO FINISH
  end

  def make_move(start_pos,end_pos, player_arr)
    if !@board[end_pos].nil?
      puts "#{player_arr[0].color}'s #{@board[start_pos].class} took #{player_arr[1].color}'s #{@board[end_pos].class}!"
      @board.jail << @board[end_pos].class
      @board[end_pos] = nil
    end
    @board[end_pos], @board[start_pos] = @board[start_pos], @board[end_pos]
    @board[end_pos].position = end_pos

  end


end

#-------------------------
#  Player Code
#-------------------------


class Player

  COL_CONVERT = {
   "A" => 0,
   "B" => 1,
   "C" => 2,
   "D" => 3,
   "E" => 4,
   "F" => 5,
   "G" => 6,
   "H" => 7
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

  def select_piece
    begin
      puts "Provide coordinates of piece to move (Col: A-H, Row: 1-8)"
      start_point = gets.chomp.split("")
      legal_move(start_point)

      start_point = [COL_CONVERT[start_point[0]],Integer(start_point[1]) - 1]
    rescue IllegalCoordinatesError
      puts "Illegal coordinates provided"
      retry
    rescue ArgumentError
      puts "Second value needs to be an integer"
      retry
    end
    start_point
  end

  def find_move
    begin
      puts "Provide coordinates of destination (Col: A-H, Row: 1-8)"
      end_point = gets.chomp.split("")
      legal_move(end_point)

      end_point = [COL_CONVERT[end_point[0]],Integer(end_point[1])-1]
    rescue IllegalCoordinatesError
      puts "Illegal coordinates provided"
      retry
    rescue ArgumentError
      puts "Second value needs to be an integer"
      retry
    end

    end_point
  end
end

#------------------------
#------------------------
#

class IllegalCoordinatesError < StandardError
end
class BadMove < StandardError
end
class BadOwnership < StandardError
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(Player.new, Player.new)
end