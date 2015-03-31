class Deck < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :cards

  enum status: [ :pick_opponent, :pick_hero, :hero_picked, :pick_cards, :completed ]

  after_initialize :defaults

  def defaults
    self.status ||= 'pick_opponent'
  end

  def set_opponent(opponent_id)
    self.update_attributes(:status => 'pick_hero', :opponent_id => opponent_id)
  end

  def pick_heroes(hero_a_id, hero_b_id, hero_c_id)
    self.update_attributes(
        :status => 'hero_picked',
        :hero_a_id => hero_a_id,
        :hero_b_id => hero_b_id,
        :hero_c_id => hero_c_id,
    )
  end

  def self.current_users_deck(user_id)
    return Deck.where(user_id: user_id).where.not(status: 4).first
  end
end
