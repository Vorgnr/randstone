class Hero < ActiveRecord::Base
  has_and_belongs_to_many :decks

  def self.random_trio
    heroes = self.all.shuffle
    return [heroes[0], heroes[1], heroes[3]]
  end
end
