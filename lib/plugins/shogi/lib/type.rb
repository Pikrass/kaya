# encoding: utf8
# Copyright (c) 2009 Paolo Capriotti <p.capriotti@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

class Promoted
  SYMBOLS = { :pawn   => 'と',
              :rook   => '龍',
              :bishop => '馬',
              :horse  => '成桂',
              :silver => '成銀',
              :lance  => '成香'
  }
  TYPES = SYMBOLS.invert

  attr_reader :demoted
  
  def initialize(type)
    @demoted = type
  end
  
  def self.demote(type)
    if promoted? type
      type.demoted
    else
      type
    end
  end
  
  def self.promote(type)
    if promoted? type
      type
    else
      new(type)
    end
  end
  
  def self.promoted?(type)
    type.respond_to? :demoted
  end
  
  def ==(other)
    self.class.promoted?(other) and
    demoted == other.demoted
  end

  def symbol
    SYMBOLS[demoted]
  end

  def type_from_symbol sym
    TYPES[sym]
  end
  
  def to_s
    "promoted_#{demoted}"
  end
end
