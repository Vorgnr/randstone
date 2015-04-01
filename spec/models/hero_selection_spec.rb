require 'rails_helper'

RSpec.describe HeroSelection, type: :model do
  describe '.save_selection' do
    context "when heroes' length is not 3" do
      it 'should raise error' do
        expect { HeroSelection.save_selection(1, []) }.to raise_error
      end
    end

    context "when heroes length is 3" do
      it 'should save selection' do
        HeroSelection.save_selection(1, [1, 2, 3])
        expect(HeroSelection.all.length).to eq 1
      end
    end
  end

  describe '.destroy_by_deck_id' do
    it 'should destroy' do
      HeroSelection.save_selection(1, [1, 2, 3])
      HeroSelection.destroy_by_deck_id(1)
      expect(HeroSelection.all.length).to eq 0
    end
  end
end
