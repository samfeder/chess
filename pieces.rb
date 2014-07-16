#-------------------------
#  Pieces Code
#-------------------------

class Piece

  attr_accessor :position, :color

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
    @previous_positions = [] #shovel in whenever a move happens
  end

  def on_the_board?(x,y)
     x <= 7 &&  y <= 7 &&  x >= 0 && y >= 0
  end

  # def move_into_check?(pos)
  #   new_board = @board.dd_board
  #   new_board[self.position] = new_board[pos]
  #   new_board.in_check?(self.color)
  # end

end



class SlidingPiece < Piece
  HORI_MOVES = [
    [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0]],
    [[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]]
  ]

  VERT_MOVES = [
    [[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]],
    [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]]
  ]
  DIAG_MOVES = [
    [[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]],
    [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]],
    [[-1,1],[-2,2],[-3,3],[-4,4],[-5,5],[-6,6],[-7,7]],
    [[1,-1],[2,-2],[3,-3],[4,-4],[5,-5],[6,-6],[7,-7]],
  ]


  def moves
    legal_moves = []
    check_moves = []
    moves_arr = send_moves
    moves_arr.each do |directions|
      directions.each do |move|
        move = [self.position[0] + move[0], self.position[1] + move[1]]
        next if !on_the_board?(move[0], move[1])
        break if !@board[move].nil? && @board[move].color == self.color
        legal_moves << move
        break if !@board[move].nil? && @board[move].color != self.color
      end

    end

    legal_moves
  end


end

class SteppingPiece < Piece

  def moves
    legal_moves = []
    moves_arr = send_moves

    moves_arr.each do |move|
      move = [self.position[0] + move[0], self.position[1] + move[1]]
      next if !on_the_board?(move[0], move[1])
      next if !@board[move].nil? && @board[move].color == self.color
      legal_moves << move
    end
    legal_moves
  end

  def on_the_board?(x,y)
     x <= 7 &&  y <= 7 &&  x >= 0 && y >= 0
  end


end

class Pawn < Piece

  MOVES_DELTA_W = [
    [0,1]
  ]

  MOVES_DELTA_B = [
    [0,-1]
  ]

  ATTACK_DELTA_W = [
    [1,1],[-1,1]
  ]

  ATTACK_DELTA_B = [
    [-1,-1],[1,-1]
  ]

  FIRST_DELTA_B = [0,-2]

  FIRST_DELTA_W = [0,2]


  def moves
    legal_moves = []
    attack_arr = []
    moves_arr = []
    if self.color == :white
      moves_arr = MOVES_DELTA_W
      moves_arr += [FIRST_DELTA_W] if self.position[1] == 1
      attack_arr = ATTACK_DELTA_W
    else
      moves_arr = MOVES_DELTA_B
      moves_arr += [FIRST_DELTA_B] if self.position[1] == 6
      attack_arr = ATTACK_DELTA_B
    end
    moves_arr.each do |move|
      move = [self.position[0] + move[0], self.position[1] + move[1]]
      next if !on_the_board?(move[0], move[1])
      next if !@board[move].nil?
      legal_moves << move
    end

    attack_arr.each do |move|
      move = [self.position[0] + move[0], self.position[1] + move[1]]
      next if !on_the_board?(move[0], move[1])
      next if @board[move].nil?
      next if @board[move].color == self.color
      legal_moves << move
    end
    legal_moves
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

  def send_moves
    MOVES_DELTA
  end

  def display
    @color == :white ? "|♔" : "|♚"
  end
end

class Queen < SlidingPiece



  def send_moves
    DIAG_MOVES + VERT_MOVES + HORI_MOVES
  end

  def display
    @color == :white ? "|♕" : "|♛"
  end

end

class Rook < SlidingPiece

  def send_moves
    VERT_MOVES + HORI_MOVES
  end

  def display
    @color == :white ? "|♖" : "|♜"
  end
end

class Bishop < SlidingPiece

  def send_moves
    DIAG_MOVES
  end

  def display
    @color == :white ? "|♗" : "|♝"
  end
end



#
# legal_moves = []
# moves_arr = send_moves
# #[[-1,0],[1,0],[0,1]]
# #[0,1]--> [0,2] --> [0,3]
# moves_arr.each do |original_move|
#   p
#   multiply = 1
#   new_move = [self.position[0] + (original_move[0]),
#               self.position[1] + (original_move[1])]
#
#   next if !on_the_board?(new_move[0],new_move[1])
#   p "Evaluating #{new_move}"
#   while @board[new_move] == nil
#
#     legal_moves += [new_move.dup]
#     p "in while: #{legal_moves}"
#     multiply += 1
#     new_move[0] = original_move[0] * multiply
#     new_move[1] = original_move[1] * multiply
#     "breaking loop before #{new_move}" if !on_the_board?(new_move[0],new_move[1])
#     break if !on_the_board?(new_move[0],new_move[1])
#
#   end
#   "breaking loop before #{new_move}"
#   if on_the_board?(new_move[0],new_move[1]) &&
#      !@board[new_move].nil? &&
#      @board[new_move].color != self.color
#
#     legal_moves += [new_move.dup]
#     p "in if: #{legal_moves}"
#   end
#
# end
# #p "#{self.class} Legal moves: #{legal_moves}"
# p "legal moves: #{self.class}#{legal_moves}"
# legal_moves