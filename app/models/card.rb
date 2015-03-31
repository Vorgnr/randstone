class Card < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :decks
  has_one :hero
end
