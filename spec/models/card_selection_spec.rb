require 'rails_helper'

RSpec.describe CardSelection, type: :model do
  describe '.save_selection' do
    context "when cards' length is not 3" do
      it 'should raise error' do
        expect { CardSelection.save_selection(1, []) }.to raise_error
      end
    end

    context "when cards length is 3" do
      it 'should save selection' do
        CardSelection.save_selection(1, [1, 2, 3])
        expect(CardSelection.all.length).to eq 1
      end
    end
  end

  describe '.destroy_by_deck_id' do
    it 'should destroy' do
      CardSelection.save_selection(1, [1, 2, 3])
      CardSelection.destroy_by_deck_id(1)
      expect(CardSelection.all.length).to eq 0
    end
  end
end
