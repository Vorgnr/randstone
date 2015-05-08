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

  describe '#set_cards_to_draw_for_current_deck' do
    it 'should save prints' do
      hero = create(:hero)
      herob = create(:hero)
      cards_with_hero = 5.times.map { create(:card, hero: hero) }
      cards_with_herob = 5.times.map { create(:card, hero: herob) }
      cards = 5.times.map { create(:card) }
      user.cards << cards[1..3] + cards_with_hero[1..3]
      user.set_cards_to_draw_for_current_deck(hero.id)
      expect(user.cards_to_draw.length).to eq 6
    end
  end

  describe '#delete_all_cards_to_draw' do
    it 'delete all user\s cards to draw' do
      user.cards << 2.times.map { create(:card) }
      user.set_cards_to_draw_for_current_deck(nil)
      expect(user.cards_to_draw.length).to eq 2
      user.delete_all_cards_to_draw
      expect(user.cards_to_draw.length).to eq 0
    end
  end
end
