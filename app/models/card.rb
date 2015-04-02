class Card < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :decks
  belongs_to :hero

  enum quality: { base: 0, common: 1, rare: 3, epic: 4, legendary: 5 }

  scope :in_collection_of, ->(user_id = nil) { where(id: CardsUsers.select('card_id').where('user_id = ?', user_id)) unless user_id.nil? }
  scope :with_qualities, ->(qualities = nil) { where(quality: qualities) unless qualities.nil? }
  scope :with_hero, ->(hero_id = nil) { where(hero_id: [nil, hero_id]) unless hero_id.nil? }

  def self.random_nuplet(n, cards)
    cards_buffer = cards.clone
    n.times.map do
      cards_buffer.slice!(rand(0..cards_buffer.length - 1))
    end
  end

  def self.i_to_quality(i)
    [ 'base', 'common', nil, 'rare', 'epic', 'legendary' ][i]
  end

  def self.random_quality
    # Legendary 1%
    # Epic 9%
    # Rare 20%
    random = rand(1..100)
    if random == 1
      quality = 5
    elsif random.between?(2, 10)
      quality = 4
    elsif random.between?(11, 32)
      quality = 3
    else
      quality = [0, 1]
    end
    quality
  end

  def self.cards_to_draw(options = {})
    Card.in_collection_of(options[:user_id]).with_qualities(options[:qualities]).with_hero(options[:hero_id])
  end
end

