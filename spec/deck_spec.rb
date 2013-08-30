require 'rspec'
require 'deck'

describe Deck do
  subject(:deck) { Deck.new }

  describe '#count' do
    it 'counts 52 cards' do
      expect(deck.count).to eq(52)
    end
  end

  describe '#shuffle!' do

    it 'shuffles the deck' do
      expect(deck.deck.object_id == deck.shuffle!.object_id).to be_true
    end
  end
end