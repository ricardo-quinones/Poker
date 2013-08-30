class Hand
  attr_accessor :player_hand

  def initialize
    @cards = []
  end
  
  def discard(value, suit)
    self.cards.delete_if { |card| card.value == value && card.suit == suit }
  end
end