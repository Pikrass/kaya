require 'games/chess/piece'

module Chess
  class State
    attr_reader :board, :castling_rights
    attr_accessor :turn, :en_passant_square
    
    class CastlingRights
      def initialize
        @wk = @wq = @bq = @bk = true
      end
      
      def king?(color)
        color == :white ? @wk : @bk
      end
      
      def queen?(color)
        color == :white ? @wq : @bq
      end
      
      def cancel_king(color)
        if color == :white
          @wk = false
        else
          @bk = false
        end
      end
      
      def cancel_queen(color)
        if color == :white
          @wq = false
        else
          @bq = false
        end
      end
    end
    
    def initialize(board)
      @board = board
      @turn = :white
      @castling_rights = CastlingRights.new
    end
    
    def setup
      setup_pawns
      setup_pieces
    end
    
    def setup_pawns
      # place pawns
      (0...@board.size.x).each do |i|
        each_color do |color|
          @board[Point.new(i, row(1, color))] = Chess::Piece.new(color, :pawn)
        end
      end
    end
    
    def setup_pieces
      [:white, :black].each do |color|
        y = row(0, color)
        [:rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook].each_with_index do |type, x|
          @board[Point.new(x, y)] = Chess::Piece.new(color, type)
        end
      end
    end
    
    def row(i, color)
      color == :white ? @board.size.y - 1 - i : i
    end
    
    def each_color
      yield :white
      yield :black
    end
    
    def perform!(move)
      if move.type == :en_passant_trigger
        self.en_passant_square = move.src + direction(turn)
      else
        self.en_passant_square = nil
      end
      
      if move.type == :en_passant_capture
        capture_on! Point.new(move.dst.x, move.src.y)
      else
        capture_on! move.dst
      end
      
      piece = @board[move.src]
      if piece and piece.type == :king
        @castling_rights.cancel_king(turn)
        @castling_rights.cancel_queen(turn)
      end
      each_color do |color|
        [:src, :dst].each do |m|
          @castling_rights.cancel_king(color) if move.send(m) == Point.new(7, row(0, color))
          @castling_rights.cancel_queen(color) if move.send(m) == Point.new(0, row(0, color))
        end
      end
      
      basic_move(move)
      
      if move.type == :promotion and move.promotion
        promote_on! move.dst, move.promotion
      end
    end
    
    def basic_move(move)
      @board[move.dst] = @board[move.src]
      @board[move.src] = nil
      switch_turn!
    end
    
    def promote_on!(p, type)
      if @board[p]
        @board[p] = Chess::Piece.new(@board[p].color, type)
      end
    end
     
    def perform_en_passant_trigger(move)
      self.en_passant_square = move.src + direction(turn)
    end
    
    def perform_en_passant_capture(move)
      capture_on! 
    end
    
    def capture_on!(p)
      @board[p] = nil
    end
    
    def switch_turn!
      self.turn = opposite_turn turn
    end
    
    def opposite_turn(t)
      t == :white ? :black : :white
    end
    
    def king_starting_position(color)
      Point.new(4, row(0, color))
    end
    
    def to_s
      board.to_s + "\nturn = #{turn}"
    end
    
    def direction(color)
      Point.new(0, color == :white ? -1 : 1)
    end
  end
end
