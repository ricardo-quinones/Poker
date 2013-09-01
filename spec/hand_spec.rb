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
        Card.new(:hearts, :seven),
        Card.new(:hearts, :six),
        Card.new(:hearts, :ace),
        Card.new(:hearts, :nine),
        Card.new(:hearts, :eight)
      ]
      expect(hand.straight_flush?).to be_false
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

  describe '#card_value' do
    it 'correctly identifies card value for four of a kind' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :king),
        Card.new(:clubs, :king),
        Card.new(:diamonds, :king),
        Card.new(:hearts, :king)
      ]
      expect(hand.card_value).to eq(11)
    end

    it 'correctly identifies a card value for full house or three of a kind' do
      hand.cards = [
        Card.new(:hearts, :ten),
        Card.new(:spades, :ten),
        Card.new(:clubs, :eight),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :eight)
      ]
      expect(hand.card_value).to eq(6)
    end

    it 'correctly identifies card value for two pair' do
      hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:spades, :seven),
        Card.new(:clubs, :two),
        Card.new(:diamonds, :two),
        Card.new(:hearts, :eight)
      ]
      expect(hand.card_value).to eq(5)
    end

    it 'correctly identifies card value for a pair' do
      hand.cards = [
        Card.new(:hearts, :queen),
        Card.new(:spades, :seven),
        Card.new(:clubs, :five),
        Card.new(:diamonds, :two),
        Card.new(:hearts, :five)
      ]
      expect(hand.card_value).to eq(3)
    end

    it 'correctly identifies card value for straight' do
      hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:spades, :six),
        Card.new(:clubs, :five),
        Card.new(:diamonds, :nine),
        Card.new(:hearts, :eight)
      ]
      expect(hand.card_value).to eq(7)
    end

    it 'correctly identifies card value for flush' do
      hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:hearts, :six),
        Card.new(:hearts, :ace),
        Card.new(:hearts, :nine),
        Card.new(:hearts, :eight)
      ]
      expect(hand.card_value).to eq(12)
    end
  end

  describe '#value' do
    it 'appropriately recognizes the hand' do
      hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:clubs, :seven),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :nine),
        Card.new(:hearts, :eight)
      ]
      expect(hand.value).to eq(2)
    end
  end

  describe '#tie' do
    it 'analyzes tie' do
      hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:clubs, :seven),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :nine),
        Card.new(:clubs, :queen)
      ]

      other_hand = Hand.new
      other_hand.cards = [
        Card.new(:diamonds, :seven),
        Card.new(:spades, :seven),
        Card.new(:clubs, :king),
        Card.new(:spades, :nine),
        Card.new(:hearts, :eight)
      ]
      expect(hand.tie(other_hand)).to eq(-1)
    end
  end

  describe '#discard' do
    it 'discards a card' do
      hand.cards = [
        Card.new(:hearts, :seven),
        Card.new(:clubs, :seven),
        Card.new(:diamonds, :eight),
        Card.new(:hearts, :nine),
        Card.new(:clubs, :queen)
      ]
      hand.discard(:seven, :hearts)
      expect(hand.cards.count).to eq(4)
    end
  end
end

