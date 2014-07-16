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
      #p " #{x}, #{y}"
      #p self.position
      #p @board[[x,y]]
      #p @board[[x,y]].color != self.color
      #p on_the_board?(self.position[0] + x, self.position[1] + y)
      if (@board[[x,y]].nil? || @board[[x,y]].color != self.color) &&
         on_the_board?(self.position[0] + x, self.position[1] + y)
        potential_positions << [self.position[0] + x, self.position[1] + y]
      else
        next
      end
    end
    p "#{self.class}"
    p potential_positions
  end

  def on_the_board?(x,y)
     x <= 7 &&  y <= 7 &&  x >= 0 && y >= 0
  end

end



class SlidingPiece < Piece

  def moves
    potential_positions = []
    self.send_moves.each do |(x, y)|
      d_x, d_y = x, y
      while on_the_board?(d_x, d_y)
        if @board[[d_x,d_y]].nil?
          potential_positions << [self.position[0] + d_x,
                                  self.position[1] + d_y]
          d_x, d_y = (d_x + x), (d_y + y)
        elsif @board[[d_x,d_y]].color == self.color
          break
        else
          potential_positions << [self.position[0] + d_x,
                                  self.position[1] + d_y]
          d_x, d_y = (d_x + x), (d_y + y)
          break
        end
      end
    end
    p "#{self.class}"
    p potential_positions
    #TODO Create logic to check if a piece is occupying position
  end




end

class SteppingPiece < Piece


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

  def send_moves
    arr = []
    # arr += [1,1] if !@board[self.position[0] + 1, self.position[1] + 1].nil? &&
    #   @board[self.position[0] + 1, self.position[1] + 1].color != :black
    # arr += [-1,1] if !@board[self.position[0] + 1, self.position[1] - 1].nil? &&
    #   @board[self.position[0] - 1, self.position[1] + 1].color != :black
    # arr += [-1,-1] if !@board[self.position[0] + 1, self.position[1] + 1].nil? &&
    #   @board[self.position[0] - 1, self.position[1] - 1].color != :white
    # arr += [1,-1] if !@board[self.position[0] + 1, self.position[1] - 1].nil? &&
    #   @board[self.position[0] + 1, self.position[1] - 1].color != :white
    if self.color == :black && self.position[1] == 6
      arr += FIRST_DELTA_B
      #check for attack     #ATTACK_DELTA_B
    elsif self.color == :white && self.position[1] == 1
      arr += FIRST_DELTA_W
      #check for attack     #ATTACK_DELTA_W
    elsif self.color == :black
      arr += MOVES_DELTA_B
      #check for attack     #ATTACK_DELTA_B
    elsif self.color == :white
      arr += MOVES_DELTA_W
      #check for attack     #ATTACK_DELTA_W
    end
    p arr
    arr
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

  def send_moves
    MOVES_DELTA
  end

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

  def send_moves
    MOVES_DELTA
  end

  def display
    @color == :white ? "|♗" : "|♝"
  end
end
