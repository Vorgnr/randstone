require 'rails_helper'

RSpec.describe Deck, type: :model do
  describe "Created deck" do
    it "should have pick_opponent status" do
      deck = Deck.new
      puts deck.inspect
      expect(deck.status).to eq('pick_opponent')
    end
  end 
end
