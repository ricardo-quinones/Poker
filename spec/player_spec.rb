require 'rspec'
require 'player'

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
end