require 'rspec'
require 'player'
require 'hand'

describe Player do
  subject(:player) { Player.new }

  describe '#bet' do
    it 'removes money from players money' do
      player.bet(45)
      expect(player.money).to eq(455)
    end

    it 'returns the amount bet' do
      expect(player.bet(50)).to eq(50)
    end
  end

  describe '#cards_to_swap' do
  	# it 'creates array of cards to swap' do
  	# 	player.hand = Hand.new
  	# 	player.hand.cards = [
   #      Card.new(:hearts, :seven),
   #      Card.new(:clubs, :seven),
   #      Card.new(:diamonds, :eight),
   #      Card.new(:hearts, :nine),
   #      Card.new(:clubs, :queen)
   #    ]
   #    expect(player.cards_to_swap("seven", "hearts")[0].class).to eq(Card)
  	# end

  	# it 'removes cards from player\'s hand' do
  	# 	player.hand = Hand.new
  	# 	player.hand.cards = [
   #      Card.new(:hearts, :seven),
   #      Card.new(:clubs, :seven),
   #      Card.new(:diamonds, :eight),
   #      Card.new(:hearts, :nine),
   #      Card.new(:clubs, :queen)
   #    ]
   #    player.cards_to_swap("seven", "hearts")
   #    expect(player.hand.cards.count).to eq(4)
  	# end

  	it 'works with multiple cards separated by commas' do
  		player.hand = Hand.new
  		player.hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:clubs, :seven),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :nine),
        Card.new(:clubs, :queen)
      ]
      expect(player.cards_to_swap.count).to eq(2)
  	end
  end
end