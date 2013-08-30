require 'card'

class Deck
  attr_reader :deck

  def self.all_cards
    [].tap do |array|
      Card.suits.each do |suit|
        Card.values.each do |value|
          array << Card.new(suit, value)
        end
      end
    end
  end

  def initialize(deck = Deck.all_cards)
    @deck = deck
  end

  def count
    deck.count
  end

  def shuffle!
    self.deck.shuffle!
  end

  def dup
    self.deck.dup
  end

  def draw
    self.deck.pop
  end
end