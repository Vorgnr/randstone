class Card < ActiveRecord::Base
  has_many :collections
  has_many :users, through: :collections

  has_and_belongs_to_many :decks
  belongs_to :hero

  enum quality: { base: 0, common: 1, rare: 3, epic: 4, legendary: 5 }

  scope :in_collection_of, ->(user_id = nil) { 
    joins(:collections)
    .where('collections.user_id' => user_id)
    .group('collections.card_id')
    .select('cards.*, count(*) as total')
    .having((user_id.is_a? Integer) ? '' : 'count(*) > 1') unless user_id.nil?
  }
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
    random = rand(1..100)
    Card.random_to_quality(random)
  end

  def self.random_to_quality(r)
    # Legendary 1%
    # Epic 9%
    # Rare 20%
    if r == 1
      quality = 5
    elsif r.between?(2, 10)
      quality = 4
    elsif r.between?(11, 32)
      quality = 3
    else
      quality = [0, 1]
    end
    quality
  end

  def self.cards_to_draw(options = {})
    Card
      .in_collection_of(options[:user_id])
      .with_qualities(options[:qualities])
      .with_hero(options[:hero_id])
  end

  def self.get_trio(options = {})
    users = options[:opponent_id].nil? ? options[:user_id] : [options[:user_id], options[:opponent_id]]
    cards = cards_to_draw(user_id: users, qualities: random_quality, hero_id: options[:hero_id])
  end

  def self.flatten(cards, is_total_must_be_clean)
    cards.each do |c|
      total = is_total_must_be_clean ? clean_total(c.total) : total
      total.times { flattened_cards.push(c) }
    end
    flattened_cards
  end

  def self.clean_total(i)
    raise('Unexpected total') unless i.between?(2, 4)
    return 2 if i == 4
    1
  end
end

