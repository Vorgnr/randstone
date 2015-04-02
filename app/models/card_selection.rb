class CardSelection < ActiveRecord::Base
  serialize :values
  belongs_to :deck

  def self.save_selection(deck_id, cards)
    raise "Unexpected card count : must be 3, have #{cards.length}" unless cards.length == 3
    CardSelection.create(deck_id: deck_id, values: cards, is_consumed: false)
  end

  def self.destroy_by_deck_id(deck_id)
    selection = CardSelection.find_by(deck_id: deck_id)
    selection.destroy
  end
end
