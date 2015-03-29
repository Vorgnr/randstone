class User < ActiveRecord::Base
  has_and_belongs_to_many :cards
  has_many :decks
  has_one :current_deck, :class_name => 'Deck'

  def has_pending_deck?
    return self.current_deck != nil
  end

  def create_deck
    deck = Deck.create(user_id: self.id)
    self.update_attribute(:current_deck, deck)
    return deck
  end
end
