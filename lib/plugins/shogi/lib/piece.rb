# encoding: utf8
# Copyright (c) 2009 Paolo Capriotti <p.capriotti@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

require_bundle 'chess', 'piece'
require_bundle 'shogi', 'type'

module Shogi

class Piece < Chess::Piece
  TYPES = { '歩' => :pawn,
            '飛' => :rook,
            '角' => :bishop,
            '桂' => :horse,
            '金' => :gold,
            '銀' => :silver,
            '香' => :lance,
            '王' => :king }
  SYMBOLS = TYPES.invert
  
  def self.type_from_symbol(sym)
    TYPES[sym] || Promoted.type_from_symbol(sym)
  end
  
  def self.symbol(type)
    base_type = Promoted.demote(type)
    if Promoted.promoted?(type)
      result = type.symbol || '?'
	else
      result = SYMBOLS[base_type] || '?'
    end
    result
  end
end

end
