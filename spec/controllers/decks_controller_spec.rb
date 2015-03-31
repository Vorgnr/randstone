require 'rails_helper'

RSpec.describe DecksController, type: :controller do
  let(:user) { create(:user) }
  let(:user_with_current_deck) { create(:user_with_current_deck) }
  let(:user_with_current_deck_and_pick_hero) { create(:user_with_current_deck_and_pick_hero) }

  # describe '#new' do
  #   context 'when user has no pending deck' do
  #     it 'should create @deck' do
  #       get :new, user_id: user.id
  #       expect(assigns(:deck)).to be #
  #     end
  #   end
  #
  #   context 'when user has pending deck' do
  #     it 'should find the deck' do
  #       get :new, user_id: user_with_current_deck.id
  #       expect(assigns(:deck)).to eq user_with_current_deck.current_deck
  #     end
  #   end
  #
  #   context "when user's deck's status is pick_hero" do
  #     it 'should set 3 random heroes' do
  #       get :new, user_id: user_with_current_deck_and_pick_hero.id
  #       puts user_with_current_deck_and_pick_hero.current_deck.pick_hero?
  #       # expect(assigns(:heroes)).to eq 3
  #     end
  #   end
  # end
end
