class Card < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :decks
  has_one :hero

  enum quality: [ :base, :common, :rare, :epic, :legendary ]

  def self.random_nuplet(n, cards)
    cards_buffer = cards.clone
    n.times.map do
      cards_buffer.slice!(rand(0..cards_buffer.length - 1))
    end
  end

  def self.filter_by
    
  end

  def self.random_quality
  end
end
