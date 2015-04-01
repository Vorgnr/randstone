require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '.random_numplet' do
    it 'should return uniq cards nuplet' do
      cards = 50.times.map { create(:card) }
      expect(cards.uniq { |c| c.id }.length).to eq 50
      nuplet = Card.random_nuplet(50, cards)
      u = nuplet.uniq { |c| c.id }
      expect(u.length).to eq 50
    end
  end
end
