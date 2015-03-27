class Deck < ActiveRecord::Base
    belongs_to :user
    has_and_belongs_to_many :cards

    enum status: [ :pick_opponent, :pick_hero, :pick_cards, :completed ]
end
