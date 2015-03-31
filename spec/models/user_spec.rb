require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_with_uncompleted_deck) { create(:user, :with_uncompleted_deck) }
  let(:user_with_completed_deck) { create(:user, :with_completed_deck) }
  let(:user) { create(:user) }

  describe '#has_pending_deck?' do
    context 'when user is not building deck' do
      it 'should be false' do
        expect(user_with_completed_deck.has_pending_deck?).to be false
      end
    end

    context 'when user is building deck' do
      it 'should be true' do
        expect(user_with_uncompleted_deck.has_pending_deck?).to be true
      end
    end
  end

  describe '#current_deck' do
    context 'when user is not building deck' do
      it 'should return nil' do
        expect(user_with_completed_deck.current_deck).to be_nil
      end
    end

    context 'when user is building deck' do
      it 'should return deck' do
        expect(user_with_uncompleted_deck.has_pending_deck?).to be true
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
