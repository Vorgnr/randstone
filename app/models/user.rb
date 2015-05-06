class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :collections
  has_many :cards, through: :collections
  
  has_many :prints
  has_many :cards_to_draw, through: :prints, :source => "card"

  has_many :decks

  after_create :set_basic_cards

  def set_basic_cards
    basic = Card.where(set: 2)
    self.cards << basic + basic
  end

  def has_pending_deck?
    return self.current_deck != nil
  end

  def current_deck
    Deck.current_users_deck(self.id)
  end

  def create_deck
    @deck = Deck.create(user_id: self.id)
  end

  def set_cards_to_draw_for_current_deck(hero_id)
    self.cards_to_draw << Card.join_collection_of(self.id).with_hero(hero_id)
  end

  def delete_all_cards_to_draw
    self.cards_to_draw.delete_all
  end
end
