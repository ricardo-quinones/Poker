# originally created by Ricardo Quinones and Cesario Uy

require_relative 'deck'
require_relative 'hand'
require_relative 'player'

class Game

  attr_accessor :players_in_round, :pot, :pot_winner, :players
  attr_reader :deck

  def initialize(num_players)
    @deck = Deck.new
    @players = [].tap { |array| num_players.times { |i| array << Player.new(Player.names(i)) } }
    @players_in_round = nil
    @pot = nil
    @pot_winner = nil
  end

  def play
    puts "Welcome to Poker!"
    loop do
      @pot = 0
      begin 
        round
      rescue StandardError => e
        puts e.message
      end
      @players_in_round.each do |player|
        self.deck.cards += player.return_cards
      end
      @players.delete_if { |player| player.money == 0 }
      break if @players.count == 1
    end

    puts "\nCongratulations, #{@players.first.name}. You won! Time to live fast and make mistakes...many, many terrible mistakes."
  end

  def round
    self.deck.shuffle!
    self.players_in_round = self.players.dup
    deal
    begin
      betting_round
    rescue StandardError => e
      puts e.message
    end
    if self.players_in_round.compact.count == 1
      pay_winner
      return nil
    end
    card_exchange
    begin
      betting_round
    rescue StandardError => e
      puts e.message
    end
    pay_winner
  end

  def deal
    self.players.each do |player|
      hand = Hand.new
      5.times do
        hand.cards << self.deck.draw
      end
      player.hand = hand
    end
  end

  def pay_winner
    self.players_in_round = self.players_in_round.compact
    if self.players_in_round.count == 1
      self.players_in_round.first.pay_winnings(@pot)
      return nil
    end
    hands = self.players_in_round.map(&:hand)
    hand_values = hands.map(&:value)
    high_hand = hand_values.max
    high_hand_index = hand_values.index(high_hand)

    if hand_values.count(high_hand) == 1
      winner = self.players_in_round[high_hand_index]
      winner.pay_winnings(@pot)
    else
      card_values = hands.map { |hand| hand.card_value if hand.value == high_hand }
      high_card_value = card_values.max
      high_card_value_index = card_values.index(high_card_value)
      high_card_value_count = card_values.count(high_card_value)

      if high_card_value_count == 1
        winner = self.players_in_round[high_card_value_index]
        winner.pay_winnings(@pot)
      elsif high_hand == 4 || high_hand == 8 || high_hand == 9
        self.players_in_round.each do |player|
          player.pay_winnings(@pot / high_card_value_count) if player.hand.value == high_hand
        end
      else
        tied_players = self.players_in_round.select { |player| player if player.hand.card_value == high_card_value }
        case tied_players.first.hand.tie(tied_players.last.hand)
        when 1
          tied_players.first.pay_winnings(@pot)
        when 0
          tied_players.first.pay_winnings(@pot / 2)
          tied_players.last.pay_winnings(@pot / 2)
        when -1
          tied_players.last.pay_winnings(@pot)
        end
      end
    end
  end

  def card_exchange
    self.players_in_round.each do |player|
      if player.exchange_cards?
        cards = player.cards_to_swap
        cards.count.times do
          player.hand.cards << self.deck.draw
        end
        self.deck.cards += cards
      end
    end
  end

  def betting_round
    current_bet = 0
    self.players_in_round.each do |player|
      player.bet_in_round = 0
    end
    raise_pos = 0
    loop do
      dup_players = self.players_in_round.dup
      dup_players.each_with_index do |player, index|
        puts "\nThe pot is $#{pot}."
        next if player.nil?
        bet = player.turn(current_bet)
        if !bet.nil?
          if bet > current_bet
            current_bet = bet
            raise_pos = index
          end
          
          @pot += bet
          if raise_pos == 0
            raise "The round of betting is over." if index == dup_players.count - 1
          else
            raise "The round of betting is over." if index == raise_pos - 1
          end
        else
          self.deck.cards += self.players_in_round[index].return_cards
          self.players_in_round[index] = nil
          if raise_pos == 0
            raise "The round of betting is over." if index == dup_players.count - 1
          else
            raise "The round of betting is over." if index == raise_pos - 1
          end
        end
      end
    end
  end
end

game = Game.new(2)
game.play