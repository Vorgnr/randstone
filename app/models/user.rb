class User < ActiveRecord::Base
  has_and_belongs_to_many :cards
  has_many :decks

  def has_pending_deck?
    return self.current_deck != nil
  end

  def current_deck
    Deck.current_users_deck(self.id)
  end

  def create_deck
    @deck = Deck.create(user_id: self.id)
  end
end
