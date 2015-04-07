class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :collections
  has_many :cards, through: :collections

  has_many :decks

  def has_pending_deck?
    return self.current_deck != nil
  end

  def current_deck
    Deck.current_users_deck(self.id)
  end

  def create_deck
    @deck = Deck.create(user_id: self.id)
  end
end
