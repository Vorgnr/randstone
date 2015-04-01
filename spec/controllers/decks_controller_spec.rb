require 'rails_helper'

RSpec.describe DecksController, type: :controller do
  let(:user) { create(:user) }
  let(:user_with_pick_hero_deck) { create(:user, :with_pick_hero_deck) }
  let(:user_with_hero_picked_deck) { create(:user, :with_heroes_picked_deck) }

  describe '#new' do
    context 'when user has no pending deck' do
      it 'should create @deck' do
        get :new, user_id: user.id
        expect(assigns(:deck)).to be
      end

      it "@deck's status should be pick_opponent" do
        get :new, user_id: user.id
        expect(assigns(:deck).pick_opponent?).to be true
      end
    end

    context 'when user has deck with pick_hero status' do
      context 'and there is not at least 3 heroes in db' do
        it 'should raise error' do
          expect {
            get :new, user_id: user_with_pick_hero_deck.id
          }.to raise_error
        end
      end

      context 'and there is sufficient amount of heroes' do
        it 'should assign heroes' do
          9.times.map { create(:hero) }
          get :new, user_id: user_with_pick_hero_deck.id
          expect(assigns(:heroes).all? { |h| h.is_a? Hero }).to be true
        end

        it 'should set @deck status to hero_picked' do
          9.times.map { create(:hero) }
          get :new, user_id: user_with_pick_hero_deck.id
          expect(assigns(:deck).hero_picked?).to be true
        end

        it "should set @deck's heroes' id" do
          9.times.map { create(:hero) }
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
        get :new, user_id: user_with_hero_picked_deck.id
        expect(assigns(:heroes).all? { |h| h.is_a? Hero }).to be true
      end
    end
  end

  describe '#add_opponent' do
    context "when user's deck's status is not pick_opponent" do
      it 'should raise error' do
        expect {
          post :add_opponent, 
            user_id: user_with_hero_picked_deck.id, 
            :opponent => { :id => "1" }
        }.to raise_error
      end
    end

    context "when opponent's id is empty" do
      it "should set @deck's opponent_id to nil" do
        opponent_id = ""
        post :add_opponent, user_id: user.id, :opponent => { :id => opponent_id }
        expect(assigns(:user).current_deck.opponent_id).to be nil
      end
    end

    context "when opponent's id is nil" do
      it "should set @deck's opponent_id to nil" do
        opponent_id = nil
        post :add_opponent, user_id: user.id, :opponent => { :id => opponent_id }
        expect(assigns(:user).current_deck.opponent_id).to be nil
      end
    end

    it "should update @deck's opponent" do
      opponent = create(:user)
      post :add_opponent, user_id: user.id, :opponent => { :id => opponent.id }
      expect(assigns(:deck).opponent_id).to eq opponent.id
    end
  end
end