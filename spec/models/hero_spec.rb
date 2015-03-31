require 'rails_helper'

RSpec.describe Hero, type: :model do
  describe '.random_trio' do
    it 'length should be 3' do
      9.times.map { create(:hero) }
      expect(Hero.random_trio.length).to eq 3
    end

    it 'should return heroes' do
      9.times.map { create(:hero) }
      expect(Hero.random_trio.all? { |h| h.is_a? Hero }).to be true
    end
  end
end
