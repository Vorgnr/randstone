class Deck < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :cards

  enum status: [ :pick_opponent, :pick_hero, :hero_picked, :pick_cards, :completed ]

  after_initialize :defaults
  
  def defaults
    self.status = 'pick_opponent'
  end

  def set_opponent(opponent_id)
    self.update_attributes(:status => "pick_hero", :opponent_id => opponent_id)
  end
end
