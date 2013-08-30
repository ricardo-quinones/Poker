# -*- coding: utf-8 -*-
require 'colorize'

class Card
  SUIT_STRINGS = {
    clubs: "♣",
    diamonds: "♦".colorize(:red),
    hearts: "♥".colorize(:red),
    spades: "♠"
  }

  VALUE_STRINGS = {
    two:    "2",
    three:  "3",
    four:   "4",
    five:   "5",
    six:    "6",
    seven:  "7",
    eight:  "8",
    nine:   "9",
    ten:    "10",
    jack:   "J",
    queen:  "Q",
    king:   "K",
    ace:    "A"
  }

  STRAIGHT_VALUES = {
    two:    0,
    three:  1,
    four:   2,
    five:   3,
    six:    4,
    seven:  5,
    eight:  6,
    nine:   7,
    ten:    8,
    jack:   9,
    queen:  10,
    king:   11,
    ace:    12
  }

  attr_reader :suit, :value

  def self.suits
    SUIT_STRINGS.keys
  end

  def self.values
    VALUE_STRINGS.keys
  end

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def straight_value
    STRAIGHT_VALUES[self.value]
  end

  def render_value
    VALUE_STRINGS[self.value]
  end

  def render_suit
    SUIT_STRINGS[self.suit]
  end
end