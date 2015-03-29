require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user_with_current_deck) { create(:user_with_current_deck) }

  describe '#has_pending_deck?' do
    context 'when current_deck_id is nil' do
      it 'should be false' do
        expect(user.has_pending_deck?).to be false
      end
    end

    context 'when current_deck_id is not nil' do
      it 'should be true' do
        expect(user_with_current_deck.has_pending_deck?).to be true
      end
    end
  end

  describe '#create_deck' do
    it 'should return the deck' do
      expect(user.create_deck).to be_a Deck
    end

    it 'should set the user\'s current deck' do
      deck = user.create_deck
      expect(user.current_deck).to eq deck
    end
  end
end
