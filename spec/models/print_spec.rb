require 'rails_helper'

RSpec.describe Print, type: :model do
  let(:user) { create(:user) }

  describe 'delete_by_user_id' do
    it 'should delete all user\'s print' do
      user.cards << 2.times.map { create(:card) }
      user.set_cards_to_draw_for_current_deck(nil)
      Print.delete_by_user_id(user.id)
      expect(Print.where(user_id: user.id).length).to eq 0
    end
  end

  describe 'delete_one_by_user_id' do
    it 'should delete one user\'s print' do
      card = create(:card)
      user.cards << [card, card]
      user.set_cards_to_draw_for_current_deck(nil)
      Print.delete_one_by_user_id(card.id, user.id)
      expect(Print.where(user_id: user.id).length).to eq 1
    end
  end

  describe 'get_available_qualities_for_user' do
    it 'should delete one user\'s print' do
      common = create(:card, :with_common_quality)
      epic = create(:card, :with_epic_quality)
      user.cards << [common, epic]
      user.set_cards_to_draw_for_current_deck(nil)
      qualities = Print.get_available_qualities_for_user(user.id)
      expect(qualities.length).to eq 2
    end
  end
end