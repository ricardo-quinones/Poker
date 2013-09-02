require_relative 'hand'

class Player
  DEFAULT_NAMES = [
    "Chris 'Jesus' Ferguson",
    "Dan 'Action Dan' Harrington",
    "Johnny 'The Orient Express' Chan",
    "Phil 'The Poker Brat' Hellmuth"
  ]

  def self.names(num)
    DEFAULT_NAMES[num]
  end

  attr_accessor :money, :hand, :bet_in_round
  attr_reader :name

  def initialize(name, money = 500)
    @name = name
    @money = money
    @hand = nil
    @bet_in_round = 0
  end

  def bet(amount)
    self.money -= amount
    amount
  end

  def fold
    nil
  end

  def turn(current_bet)
    begin
      self.hand.render_cards
      puts "\n#{self.name}, you have $#{@money} in your bankroll."
      puts "Type 'b' to bet or press enter to check?" if current_bet == 0
      puts "It is $#{current_bet - self.bet_in_round} to call." if current_bet > 0
      puts "Would you like to call, raise, or fold?" if current_bet > 0 && self.money > current_bet - self.bet_in_round
      puts "Would you like to call or fold?" if current_bet - self.bet_in_round == self.money
      case parse(gets)
      when "b"
        puts "\nHow much would you like to bet?"
        begin
          bet = gets.chomp.to_i
          raise "That's not a number." unless bet > 0
          raise "You don't have that much money" if bet > self.money
        rescue StandardError => e
          puts e.message
          retry
        end
          bet = self.bet(bet)
          self.bet_in_round += bet
          bet
      when "r"
        raise "You don't have enough money to raise." if current_bet - self.bet_in_round == self.money
        puts "\nBy how much would you like to raise?"
        begin
          raise_bet = gets.chomp.to_i
          raise "That's not a number." unless raise_bet > 0
          raise "You don't have that much money." if current_bet + raise_bet > self.money
        rescue StandardError => e
          puts e.message
          retry
        end
        call_bet = current_bet - self.bet_in_round
        bet = self.bet(call_bet + raise_bet)
        self.bet_in_round += bet
        bet
      when "c"
        call_bet = current_bet - self.bet_in_round
        bet = self.bet(call_bet)
        self.bet_in_round += bet
        bet
      when "f"
        self.fold
      when "\n"
        self.bet(0)
      else
        raise "Sorry, try selecting again."
      end
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def parse(user_input)
    user_input[/^[brcf\n]/]
  end

  def cards_to_swap
    puts "\nWhat cards would you like to exchange?"
    cards = []
    card_strings = gets.chomp.split(",").map(&:strip)
    card_syms = card_strings.map { |card_string| card_string.split(" ").map(&:to_sym) }
    card_syms.each do |card_sym|
      value, suit = card_sym[0], card_sym[1]
      cards << self.hand.strings_to_card(value, suit)
      self.hand.discard(value, suit)
    end

    cards
  end
  
  def exchange_cards?
    self.hand.render_cards
    puts "\n#{self.name}, would you like to exchange cards?"
    gets.chomp.downcase[0] == "y"
  end

  def pay_winnings(pot)
    puts "\n#{self.name} won the pot!"
    @money += pot
  end

  def return_cards
    cards = self.hand.cards.dup
    self.hand = nil
    cards
  end
end