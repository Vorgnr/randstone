class Card < ActiveRecord::Base
  has_many :collections
  has_many :users, through: :collections

  has_and_belongs_to_many :decks
  belongs_to :hero

  enum quality: { base: 0, common: 1, rare: 3, epic: 4, legendary: 5 }

  scope :in_collection_of, ->(user_id = nil) { 
    joins(:collections)
    .where('collections.user_id' => user_id)
    .group('cards.id')
    .select('cards.*, count(*) as total')
    .having((user_id.is_a? Integer) ? '' : 'count(*) > 1') unless user_id.nil?
  }
  scope :all_with_collection_of, ->(user_id, limit = 20, offset = 0) {
    joins("left outer join collections on collections.card_id = cards.id and collections.user_id = #{user_id}")
    .group('cards.id')
    .select('cards.*, count(collections.id) as total')
    .order('cards.cost')
    .limit(limit)
    .offset(offset)
  }

  scope :with_qualities, ->(qualities = nil) { where(quality: qualities) unless qualities.nil? }
  scope :with_hero, ->(hero_id = nil) { where(hero_id: [nil, hero_id]) unless hero_id.nil? }

  def self.random_nuplet(n, cards)
    raise('Not enough card') if cards.nil? || cards.length < n
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

  # def available_qualities
  #   self.cards.group(:quality).count
  # end

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
    if options[:opponent_id].nil?
      is_total_must_be_clean = false
      users = options[:user_id]
    else
      is_total_must_be_clean = true
      users = [options[:user_id], options[:opponent_id]]
    end

    cards = cards_to_draw(user_id: users, hero_id: options[:hero_id])
    
    flattened_cards = Card.flatten(cards, is_total_must_be_clean)
    if !options[:cards_in_deck].nil?
      Card.remove_cards_already_in_deck(options[:cards_in_deck], flattened_cards)
    end
    random_nuplet(3, flattened_cards.uniq)
  end

  def self.flatten(cards, is_total_must_be_clean = false)
    flattened_cards = []
    cards.each do |c|
      total = is_total_must_be_clean ? clean_total(c.total) : c.total
      total.times { flattened_cards.push(c) }
    end
    flattened_cards
  end

  def self.remove_cards_already_in_deck(cards_in_deck, cards)
    cards_in_deck.each do |c|
      index_to_delete = cards.index { |f| f.id == c.id }
      cards.delete_at(index_to_delete) unless index_to_delete.nil?
    end
  end

  def self.clean_total(i)
    raise('Unexpected total') unless i.between?(2, 4)
    i == 4 ? 2 : 1
  end
end

