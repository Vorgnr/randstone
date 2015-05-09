class Deck < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :cards
  belongs_to :hero

  enum status: [ :pick_hero, :hero_picked, :pick_cards, :completed ]

  after_initialize :defaults

  def defaults
    self.status ||= 'pick_hero'
  end

  def pick_heroes(heroes)
    heroes = heroes.map { |h| h.id } if heroes.all? { |h| h.is_a? Hero }
    HeroSelection.save_selection(self.id, heroes)
    self.update_attributes(status: 'hero_picked')
  end

  def set_hero(hero_id)
    self.update_attributes(status: 'pick_cards', hero_id: hero_id)
  end

  def self.current_user_deck(user_id)
    return Deck.where(user_id: user_id).where.not(status: 3).first
  end

  def user_completed_decks(user_id)
    return Deck.where(user_id: user_id).where(status: 3)
  end

  def current_cards_selection
    CardSelection.where(deck_id: self.id, is_consumed: false).first
  end

  def create_card_selection(cards)
    CardSelection.save_selection(self.id, cards)
  end

  def add_card(card)
    self.cards << card
    cards_selection = self.current_cards_selection
    cards_selection.destroy unless cards_selection.nil? 
    if self.cards.length == 30
      self.complete
    end
  end

  def complete
    self.update_attributes(status: 'completed')
    Print.delete_by_user_id(self.user_id)
  end
end
