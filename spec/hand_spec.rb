require 'rspec'
require 'hand'
require 'deck'

describe Hand do
  let(:card) { double("card") }
  subject(:hand) { Hand.new }

  describe '#cards' do
    it 'has five cards' do
      hand.deal
      expect(hand.cards.count).to eq(5)
    end
  end

  describe '#flush?' do
    it 'is a flush hand' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:hearts, :seven),
        Card.new(:hearts, :eight),
        Card.new(:hearts, :king),
        Card.new(:hearts, :four)
      ]
      expect(hand.flush?).to be_true
    end
  end

  describe '#straight?' do
    it 'is a straight hand' do
      hand.cards = [
        Card.new(:spades, :ten),
        Card.new(:hearts, :jack),
        Card.new(:clubs, :queen),
        Card.new(:hearts, :king),
        Card.new(:hearts, :ace)
      ]
      expect(hand.straight?).to be_true
    end
  end

  describe '#straight_flush?' do
    it 'is a straight flush' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:hearts, :jack),
        Card.new(:hearts, :nine),
        Card.new(:hearts, :seven),
        Card.new(:hearts, :eight)
      ]
      expect(hand.straight_flush?).to be_true
    end
  end

  describe '#royal_flush?' do
    it 'is a royal flush' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:hearts, :jack),
        Card.new(:hearts, :queen),
        Card.new(:hearts, :king),
        Card.new(:hearts, :ace)
      ]
      expect(hand.royal_flush?).to be_true
    end
  end

  describe '#four_of_a_kind?' do
    it 'is four of a kind' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :ten),
        Card.new(:clubs, :ten),
        Card.new(:diamonds, :ten),
        Card.new(:hearts, :ace)
      ]
      expect(hand.four_of_a_kind?).to be_true
    end
  end

  describe '#three_of_a_kind?' do
    it 'is three of a kind' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :ten),
        Card.new(:clubs, :ten),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :ace)
      ]
      expect(hand.three_of_a_kind?).to be_true
    end
  end

  describe '#pair?' do
    it 'is a pair' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :ten),
        Card.new(:clubs, :king),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :ace)
      ]
      expect(hand.pair?).to be_true
    end
  end

  describe '#two_pair?' do
    it 'identifies two pair' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :ten),
        Card.new(:clubs, :king),
        Card.new(:diamonds, :king),
        Card.new(:hearts, :ace)
      ]
      expect(hand.two_pair?).to be_true
    end
  end

  describe '#full_house?' do
    it 'identifies a full house' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :ten),
        Card.new(:clubs, :king),
        Card.new(:diamonds, :king),
        Card.new(:hearts, :king)
      ]
      expect(hand.full_house?).to be_true
    end
  end
end

