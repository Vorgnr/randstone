require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:deck) { create(:deck) }

  describe 'Created deck' do
    it 'should have pick_opponent status' do
      deck = Deck.new
      expect(deck.status).to eq('pick_opponent')
    end
  end

  describe '#set_opponent' do
    it 'should set opponent' do
      deck.set_opponent(5)
      expect(deck.opponent_id).to eq(5)
    end

    it 'should set status to pick_hero' do
      deck.set_opponent(5)
      expect(deck.status).to eq('pick_hero')
    end
  end

  describe '#pick_heroes' do
    it 'should set status to hero_picked  ' do
      hero_a = create(:hero)
      hero_b = create(:hero)
      hero_c = create(:hero)
      deck.pick_heroes(hero_a, hero_b, hero_c)
      expect(deck.hero_picked?).to be true
    end

    it 'should set deck\'s heroes' do
      hero_a = create(:hero)
      hero_b = create(:hero)
      hero_c = create(:hero)
      deck.pick_heroes(hero_a.id, hero_b.id, hero_c.id)
      expect(deck.hero_a_id).to eq hero_a.id
      expect(deck.hero_b_id).to eq hero_b.id
      expect(deck.hero_c_id).to eq hero_c.id
    end
  end

  describe '.current_users_deck' do
    context 'when user does have one' do
      it 'should return user\'s deck ' do
        user_with_uncompleted_deck = create(:user, :with_uncompleted_deck)
        users_deck = Deck.current_users_deck(user_with_uncompleted_deck.id)
        expect(users_deck).to be_a Deck
        expect(users_deck.completed?).to be false
      end
    end

    context 'when user does not have one' do
      it 'should return nil ' do
        user = create(:user)
        expect(Deck.current_users_deck(user.id)).to be nil
      end
    end
  end
end
