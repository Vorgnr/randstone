require 'rails_helper'

RSpec.describe Print, type: :model do
  describe 'delete_by_user_id' do
    let(:user) { create(:user) }
    it 'should delete all user\'s print' do
      user.cards << 2.times.map { create(:card) }
      user.set_cards_to_draw_for_current_deck(nil)
      Print.delete_by_user_id(user.id)
      expect(Print.where(user_id: user.id).length).to eq 0
    end
  end
end