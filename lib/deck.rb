require_relative 'card'

class Deck
  attr_accessor :cards

  def self.all_cards
    [].tap do |array|
      Card.suits.each do |suit|
        Card.values.each do |value|
          array << Card.new(suit, value)
        end
      end
    end
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def count
    self.cards.count
  end

  def shuffle!
    self.cards.shuffle!
  end

  def dup
    self.cards.dup
  end

  def draw
    self.cards.shift
  end

  def return_cards(cards)
    self.cards += cards
  end
end