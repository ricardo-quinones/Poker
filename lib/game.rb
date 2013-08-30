require_relative 'deck'
require_relative 'hand'
require_relative 'player'

class Game

  attr_accessor :players_in_round
  attr_reader :players, :deck

  def initialize(num_players)
    @deck = Deck.new
    @players = Array.new(num_players) { Player.new }
    @players_in_round = nil
  end

  def play
    puts "Welcome to Poker!"
    loop do
      round
    end
  end

  def round
    self.deck.shuffle!
    self.players_in_round = self.players.dup
    deal
    pot = 0
    begin
      pot = betting_round(pot)
    rescue StandardError => e
      puts e.message
    end
    card_exchange
    pot = betting_round(pot)
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

  def card_exchange
    self.players_in_round.each do |player|
      if player.exchange_cards? #make this method
        num = player.cards_to_swap
        num.times do
          player.hand.cards << self.deck.draw
        end
      end
    end
  end

  def betting_round(pot)
    current_bet = 0
    loop do
      raise_index = 0
      dup_players = self.players_in_round.dup
      dup_players.each_with_index do |player, index|
        puts "The pot is $#{pot} and the current bet is $#{current_bet}"
        next if player.nil?
        bet = player.turn(current_bet)
        unless bet.nil?
          if bet > current_bet
            current_bet = bet
            raise_index = index
          end
          raise_index ||= 0
          pot += bet
          if raise_index == 0
            raise "The round of betting is over." if index == dup_players.count - 1
          else
            raise "The round of betting is over." if index == raise_index - 1
          end
        else
          self.players_in_round[index] = nil
        end
      end
    end

    pot
  end

  def tie_breaker(hand1, hand2)#possibly want to use players to determine winner
    high_card1 = (hand1 - hand2).max
    high_card2 = (hand2 - hand1).max
    high_card1 > high_card2 ? hand1 : hand2
  end
end

game = Game.new(2)
game.play