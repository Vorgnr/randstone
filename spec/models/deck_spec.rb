require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:deck) { create(:deck) }

  describe 'Created deck' do
    it 'should have pick_opponent status' do
      deck = Deck.new
      expect(deck.status).to eq('pick_hero')
    end
  end

  describe '#pick_heroes' do
    it 'should set status to hero_picked  ' do
      hero_a = create(:hero)
      hero_b = create(:hero)
      hero_c = create(:hero)
      deck.pick_heroes([hero_a, hero_b, hero_c])
      expect(deck.hero_picked?).to be true
    end

    it 'should set deck\'s heroes' do
      hero_a = create(:hero)
      hero_b = create(:hero)
      hero_c = create(:hero)
      deck.pick_heroes([hero_a, hero_b, hero_c])
      heroSelection = HeroSelection.find_by(deck_id: deck.id)
      expect(heroSelection).to be_a HeroSelection
      expect(heroSelection.values).to eq [hero_a.id, hero_b.id, hero_c.id]
    end
  end

  describe '.current_user_deck' do
    context 'when user does have one' do
      it 'should return user\'s deck ' do
        user_with_uncompleted_deck = create(:user, :with_uncompleted_deck)
        user_completed_decks = Deck.current_user_deck(user_with_uncompleted_deck.id)
        expect(user_completed_decks).to be_a Deck
        expect(user_completed_decks.completed?).to be false
      end
    end

    context 'when user does not have one' do
      it 'should return nil ' do
        user = create(:user)
        expect(Deck.current_user_deck(user.id)).to be nil
      end
    end
  end

  describe '#current_cards_selection' do
    it "should return deck's current card selection" do
      cards = 3.times.map { create(:card) }
      selection = CardSelection.save_selection(deck.id, cards.map { |c| c.id })
      expect(deck.current_cards_selection).to eq selection
    end
  end

  describe '#create_card_selection' do
    it 'should create a card selection' do
      cards = 3.times.map { create(:card) }
      card_selection = deck.create_card_selection(cards.map { |c| c.id })
      expect(card_selection).to eq deck.current_cards_selection
      expect(card_selection.is_consumed).to be false
    end
  end

  describe '#add_card' do
    context 'when deck has less than 29 cards' do
      it 'should add card to deck' do
        deck.add_card(create(:card))
        expect(deck.cards.length).to eq 1
      end
    end
    
    context 'when deck has 29 cards' do
      it 'should add card to deck and set status to completed' do
        cards = 29.times.map { create(:card) }
        deck.cards << cards
        deck.add_card(create(:card))
        expect(deck.cards.length).to eq 30
        expect(deck.completed?).to be true
      end

      it 'should destroy deck\'s card selection' do
        cards = 29.times.map { create(:card) }
        deck.cards << cards
        card_to_add = create(:card)
        deck.create_card_selection([cards[0].id, cards[1].id, card_to_add.id])
        deck.add_card(card_to_add)
        expect(deck.current_cards_selection).to eq nil
      end
    end
  end

  describe '#user_completed_decks' do
    it 'should retrieve all completed user\'s deck' do
      deck_completed = create(:deck_completed)
      user = create(:user)
      user.decks << [deck_completed, deck]
      expect(deck.user_completed_decks(user.id).length).to eq 1
    end
  end 
end
