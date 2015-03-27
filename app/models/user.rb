class User < ActiveRecord::Base
  has_and_belongs_to_many :cards
  has_many :decks

  def has_pending_deck?
    return self.current_deck_id != nil
  end
end
