require 'rails_helper'

def sign_in(user)
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in user
end

RSpec.describe DecksController, type: :controller do
  let(:user) { create(:user) }
  let(:user_with_pick_hero_deck) { create(:user, :with_pick_hero_deck) }
  let(:user_with_hero_picked_deck) { create(:user, :with_heroes_picked_deck) }
  let(:user_with_pick_cards_deck) { create(:user, :with_pick_cards_deck) }
  let(:user_with_completed_deck) { create(:user, :with_completed_deck) }

  describe '#new' do
    context 'when user has no pending deck' do
      it 'should create @deck' do
        9.times.map { create(:hero) }
        sign_in(user)
        get :new
        expect(assigns(:deck)).to be
      end

      it "@deck's status should be hero_picked" do
        9.times.map { create(:hero) }
        sign_in(user)
        get :new
        expect(assigns(:deck).hero_picked?).to be true
      end
    end

    context 'when user has deck with pick_hero status' do
      context 'and there is not at least 3 heroes in db' do
        it 'should raise error' do
          sign_in(user_with_pick_hero_deck)
          expect {
            get :new
          }.to raise_error
        end
      end

      context 'and there is sufficient amount of heroes' do
        it 'should assign heroes' do
          9.times.map { create(:hero) }
          sign_in(user_with_pick_hero_deck)
          get :new
          expect(assigns(:heroes).all? { |h| h.is_a? Hero }).to be true
        end

        it 'should set @deck status to hero_picked' do
          9.times.map { create(:hero) }
          sign_in(user_with_pick_hero_deck)
          get :new, user_id: user_with_pick_hero_deck.id
          expect(assigns(:deck).hero_picked?).to be true
        end

        it "should set @deck's heroes' id" do
          9.times.map { create(:hero) }
          sign_in(user_with_pick_hero_deck)
          get :new, user_id: user_with_pick_hero_deck.id
          expect(assigns(:heroes).map {|h| h.id}).to eq HeroSelection.find_by(deck_id: assigns(:deck).id).values
        end
      end
    end

    # Todo - Improve model
    context 'when user has deck with hero picked status' do
      it 'should assign @heroes' do
        Hero.create(id: 1)
        Hero.create(id: 2)
        Hero.create(id: 3)
        d = user_with_hero_picked_deck.current_deck
        HeroSelection.save_selection(d.id, [1, 2, 3])
        sign_in(user_with_hero_picked_deck)
        get :new
        expect(assigns(:heroes).all? { |h| h.is_a? Hero }).to be true
      end
    end

    context 'when user has deck with pick_cards status' do
      context 'when @desk has no current card selection' do
        it 'should assign @cards' do
          cards = 3.times.map { create(:card, :with_common_quality) }
          user_with_pick_cards_deck.cards << cards
          user_with_pick_cards_deck.set_cards_to_draw_for_current_deck nil
          sign_in(user_with_pick_cards_deck)
          get :new
          expect(assigns(:cards).length).to eq 3
        end
      end

      context 'when @deck has current card selection' do
        it 'should assign @cards' do
          cards = 3.times.map { create(:card) }
          user_with_pick_cards_deck.cards << cards
          user_with_pick_cards_deck.current_deck.create_card_selection(cards.map { |c| c.id })
          sign_in(user_with_pick_cards_deck)
          get :new
          expect(assigns(:cards).length).to eq 3
        end
      end
    end
  end

  describe '#add_hero' do
    context 'when !@deck.hero_picked?' do
      it 'raise error' do
        sign_in(user)
        Hero.create(id: 1)
        expect {
          post :add_hero, 
            :hero => 1
        }.to raise_error("Unexpected deck's status")
      end
    end

    context 'when hero params is nil' do
      it 'raise error' do
        sign_in(user_with_hero_picked_deck)
        Hero.create(id: 1)
        expect {
          post :add_hero, 
            :hero => nil
        }.to raise_error('Hero can not be nil or empty')
      end
    end

    context 'when hero params is empty' do
      it 'raise error' do
        sign_in(user_with_hero_picked_deck)
        Hero.create(id: 1)
        expect {
          post :add_hero, 
            user_id: user_with_hero_picked_deck.id, 
            :hero => ''
        }.to raise_error('Hero can not be nil or empty')
      end
    end

    it "should set @deck's status to pick_cards" do
        Hero.create(id: 1)
        sign_in(user_with_hero_picked_deck)
        post :add_hero, hero: 1
        expect(assigns(:deck).status).to eq 'pick_cards'
    end

    it "should set @deck's hero" do
      Hero.create(id: 1)
      sign_in(user_with_hero_picked_deck)
      post :add_hero, hero: 1
      expect(assigns(:deck).hero).to eq Hero.find(1)
    end

    it 'should set user cards to draw' do
      hero = Hero.create(id: 1)
      user_with_hero_picked_deck.cards << create(:card, hero: hero)
      sign_in(user_with_hero_picked_deck)
      post :add_hero, hero: 1
      expect(assigns(:user).cards_to_draw.length).to eq 1
    end
  end

  describe '#add_card' do
    let(:card) { create(:card) }
    before(:each) do
      user_with_pick_cards_deck.cards << card
      user_with_pick_cards_deck.set_cards_to_draw_for_current_deck(nil)
    end

    context 'when @deck has not pick_cards status' do
      it 'should raise error' do
        sign_in(user)
        expect { post :add_card, card: card.id }.to raise_error("Unexpected deck's status")
      end
    end

    context 'when card is nil or empty' do
      it 'should raise error' do
        sign_in(user_with_pick_cards_deck)
        expect { post :add_card, card: '' }.to raise_error("Card can not be nil or empty")
        expect { post :add_card, card: nil }.to raise_error("Card can not be nil or empty")
      end
    end

    context 'when there are 29 cards in thuser_with_pick_cards_decke deck' do
      it 'should redirect to decks_path' do
        sign_in(user_with_pick_cards_deck)
        user_with_pick_cards_deck.current_deck.cards << 29.times.map { create(:card) }
        expect(post :add_card, card: card.id).to redirect_to decks_path
      end
    end

    context 'when there are less than 29 cards in the deck' do
      it 'should redirect to new_deck_path' do
        sign_in(user_with_pick_cards_deck)
        user_with_pick_cards_deck.current_deck.cards << 5.times.map { create(:card) }
        expect(post :add_card, card: card.id).to redirect_to new_deck_path
      end
    end

    it 'should add card' do
      sign_in(user_with_pick_cards_deck)
      expect(user_with_pick_cards_deck.current_deck.cards.length).to eq 0
      expect(post :add_card, card: card.id)
      expect(user_with_pick_cards_deck.current_deck.cards.length).to eq 1
    end
  end
end