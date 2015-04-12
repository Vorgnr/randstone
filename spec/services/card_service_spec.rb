require 'rails_helper'

RSpec.describe CardService, type: :service do
  let(:dummy_service) { CardService.new(cards: 1) }
  describe 'initialize' do
    context 'when params[:cards] is nil' do
      it 'should raise error' do
        expect { CardService.new }.to raise_error 'Cards param must be set'
      end
    end
  end

  describe '#random_ntuple' do
    context 'when @cards.length < n' do
      it 'should raise error' do
        cards = 2.times.map { create(:card) }
        service = CardService.new(cards: cards)
        expect { service.random_ntuple(3) }.to raise_error 'n must be lower than @cards.length'
      end
    end

    context 'when params[:cards] is not nil' do
      it 'should return uniq cards n-tuple' do
        cards = 5.times.map { create(:card) }
        service = CardService.new(cards: cards)
        nuplet = service.random_ntuple(5)
        u = nuplet.uniq { |c| c.id }
        expect(u.length).to eq 5
      end
    end
  end

  describe 'clean_total' do
    it 'should return expected clean total' do
      expect { dummy_service.clean_total(0) }.to raise_error
      expect { dummy_service.clean_total(1) }.to raise_error
      expect(dummy_service.clean_total(2)).to eq 1
      expect(dummy_service.clean_total(3)).to eq 1
      expect(dummy_service.clean_total(4)).to eq 2
    end
  end
end