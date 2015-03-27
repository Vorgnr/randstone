require 'rails_helper'

RSpec.describe Deck, type: :model do
  let(:deck) { create(:deck) }

  describe "Created deck" do
    it "should have pick_opponent status" do
      deck = Deck.new
      puts deck.inspect
      expect(deck.status).to eq('pick_opponent')
    end
  end

  describe "#set_opponent" do
    it "should set opponent" do
      deck.set_opponent(5)
      expect(deck.opponent_id).to eq(5)
    end

    it "should set status to pick_hero" do
      deck.set_opponent(5)
      expect(deck.status).to eq('pick_hero')
    end
  end
end
