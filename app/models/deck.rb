class Deck < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :cards
  belongs_to :hero

  enum status: [ :pick_opponent, :pick_hero, :hero_picked, :pick_cards, :completed ]

  after_initialize :defaults

  def defaults
    self.status ||= 'pick_opponent'
  end

  def set_opponent(opponent_id)
    self.update_attributes(:status => 'pick_hero', :opponent_id => opponent_id)
  end

  def pick_heroes(heroes)
    heroes = heroes.map { |h| h.id } if heroes.all? { |h| h.is_a? Hero }
    HeroSelection.save_selection(self.id, heroes)
    self.update_attributes(:status => 'hero_picked')
  end

  def set_hero(hero_id)
    self.update_attributes(status: 'pick_cards', hero_id: hero_id)
  end

  def self.current_users_deck(user_id)
    return Deck.where(user_id: user_id).where.not(status: 4).first
  end
end
