require_relative 'hand'

class Player

  attr_accessor :money, :hand

  def initialize(money = 500)
    #@name = name
    @money = money
    @hand = nil
  end

  def bet(amount)
    self.money -= amount
    amount
  end

  def fold
    nil
  end

  def turn(current_bet)
    self.hand.cards.each_with_index do |card, index|
      print "#{card.render_value} #{card.render_suit}"
      print ", " unless index == 4
    end
    puts "\nType 'b' to bet or press enter to check?" if current_bet == 0
    puts "\nWould you like to call, raise, or fold?" if current_bet > 0
    case parse(gets)
    when "b"
      puts "\nHow much would you like to bet?"
      self.bet(gets.chomp.to_i)
    when "r"
      puts "\nBy how much would you like to raise?"
      self.bet(current_bet + gets.chomp.to_i)
    when "c"
      self.bet(current_bet)
    when "f"
      self.fold
    when "\n"
      self.bet(0)
    end
  end

  def parse(user_input)
    user_input[/^[brcf\n]/]
  end

  def cards_to_swap
    puts "\nWhat cards would you like to exchange?"
    cards = gets.chomp.split(",")
    cards.each do |card_string|
      card.string.split(" ").each do |value, suit|
        self.hand.discard(value, suit)
      end
    end

    cards.count
  end
  
  def exchange_cards?
    #write me PLEASE!!
  end

end