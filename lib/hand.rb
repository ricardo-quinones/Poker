require_relative 'card'
require_relative 'deck'

class Hand
  attr_accessor :player_hand, :cards

  def initialize
    @cards = []
    @type_of_hand = nil
    @value = nil
  end

  def discard(value, suit)
    self.cards.delete_if { |card| card.value == value && card.suit == suit }
  end

  #remove temp method later
  def deal
    deck = Deck.new
    deck.shuffle!
    5.times do
      self.cards << deck.draw
    end
  end

  #remove temp method later
  def render_cards
    self.cards.each_with_index do |card, index|
      print "#{card.render_value} #{card.render_suit}"
      print ", " unless index == 4
    end
  end

  def hand_value
    self.value = card_value
    case
    when royal_flush?
      self.type_of_hand = :royal_flush
    when straight_flush?
      self.type_of_hand = :straight_flush
    when four_of_a_kind?
      self.type_of_hand = :four_of_a_kind
    when full_house?
      self.type_of_hand = :full_house
    when flush?
      self.type_of_hand = :flush
    when straight?
      self.type_of_hand = :straight
    when three_of_a_kind?
      self.type_of_hand = :three_of_a_kind
    when two_pair?
      self.type_of_hand = :two_pair
    when pair?
      self.type_of_hand = :pair
    else
      self.type_of_hand = :high_card
    end
  end

  def card_value
    card_values = cards.map { |card| card.straight_value }
    case
    when card_values.any? { |value| card_values.count(value) == 4 }
      card_values.select { |value| card_values.count == 4 }.max
    when card_values.any? { |value| card_values.count(value) == 3 }
      card_values.select { |value| card_values.count == 3 }.max
    when card_values.any? { |value| card_values.count(value) == 2 }
      card_values.select { |value| card_values.count == 3 }.max
    else
      card_values.max
    end
  end

  def flush?
    suit = cards[0].suit
    cards.all? { |card| card.suit == suit }
  end

  def straight?
    card_values = cards.map { |card| card.straight_value }

    min = card_values.min

    return true if card_values.uniq.count == cards.count
    card_values.all? { |value| value.between?(min, min + 4)}
  end

  def straight_flush?
    flush? && straight?
  end

  def royal_flush?
    card_values = cards.map { |card| card.straight_value }
    straight_flush? && card_values.min == 8
  end

  def four_of_a_kind?
    card_values = cards.map { |card| card.straight_value }
    card_values.any? { |value| card_values.count(value) == 4 }
  end

  def three_of_a_kind?
    card_values = cards.map { |card| card.straight_value }
    card_values.any? { |value| card_values.count(value) == 3 }
  end

  def pair?
    card_values = cards.map { |card| card.straight_value }
    card_values.any? { |value| card_values.count(value) == 2 }
  end

  def two_pair?
    card_values = cards.map { |card| card.straight_value }
    pairs = card_values.select { |value| card_values.count(value) == 2 }
    pairs.count == 4
  end

  def full_house?
    pair? && three_of_a_kind?
  end

  def hand_value

  end

end