require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user_with_pending_deck) { create(:user_with_pending_deck) }

  describe "#has_pending_deck?" do
    context "when current_deck_id is nil" do
      it "should be false" do
        expect(user.has_pending_deck?).to be false
      end
    end

    context "when current_deck_id is not nil" do
      it "should be true" do
        expect(user.has_pending_deck?).to be true
      end
    end
  end
end
