require_relative 'card'
require_relative 'deck'

class Hand
  HAND_VALUES = {
    high_card:        0,
    pair:             1,
    two_pair:         2,
    three_of_a_kind:  3,
    straight:         4,
    flush:            5,
    full_house:       6,
    four_of_a_kind:   7,
    straight_flush:   8,
    royal_flush:      9
  }
  attr_accessor :player_hand, :cards

  def initialize
    @cards = []
  end

  def discard(value, suit)
    self.cards.delete_if { |card| card.value == value && card.suit == suit }
  end

  def strings_to_card(value, suit)
    self.cards.find { |card| card.value == value && card.suit == suit }
  end

  def render_cards
    print "\n"
    self.cards.each_with_index do |card, index|
      puts "#{card.render_value} #{card.render_suit}"
    end
  end

  def value
    HAND_VALUES[assign_hand]
  end

  def tie(other_hand)
    high_card = (self.cards.map(&:straight_value) - other_hand.cards.map(&:straight_value)).max
    other_hand_high_card = (other_hand.cards.map(&:straight_value) - self.cards.map(&:straight_value)).max
    high_card <=> other_hand_high_card
  end

  def assign_hand
    case
    when royal_flush?
      :royal_flush
    when straight_flush?
      :straight_flush
    when four_of_a_kind?
      :four_of_a_kind
    when full_house?
      :full_house
    when flush?
      :flush
    when straight?
      :straight
    when three_of_a_kind?
      :three_of_a_kind
    when two_pair?
      :two_pair
    when pair?
      :pair
    else
      :high_card
    end
  end

  # This stores the value of the pertinent hand; if the hand is a pair of sevens, it stores the seven value;
  # if the hand is two pair with king pair high, it stores the  king value, etc. For flushes and straights,
  # it stores the high card of the straight or flush. Tie-breakers will be analyzed elsewhere, e.g. two hands
  # both with a pair of queens (high card analysis).
  def card_value
    card_values = cards.map { |card| card.straight_value }
    [4, 3, 2].each do |num|
      if card_values.any? { |value| card_values.count(value) == num }
        return card_values.select { |value| card_values.count(value) == num }.max
      end
    end
    card_values.max
  end

  def flush?
    suit = cards[0].suit
    cards.all? { |card| card.suit == suit }
  end

  def straight?
    card_values = cards.map { |card| card.straight_value }

    min = card_values.min

    if card_values.uniq.count == cards.count
      return true if card_values.all? { |value| value.between?(min, min + 4)}
    end

    false
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
end