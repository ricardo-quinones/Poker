require 'deck'
require 'hand'
require 'player'

class Game

  def initialize(num_players)
    @deck = Deck.new
    @players = Array.new(num_players) { Player.new }
    @pot = 0
  end

  def play
    puts "Welcome to Poker!"
    loop do
      round
    end
  end
  
  def round    
    self.deck.shuffle!
    dup_players = self.players.dup
    deal
    betting_round(dup_players)
    card_exchange(dup_players)
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
  
  def card_exchange(dup_players)
    dup_players.each do |player|
      player.exchange_cards?
      num = player.
    end
  end
  
  def betting_round(dup_players)
    dup_players.dup.each do |player|
      bet = player.turn
      self.pot += bet unless bet.nil?
      dup_players.delete(player) if bet.nil?
    end
  end
end