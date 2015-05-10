class Print < ActiveRecord::Base
  belongs_to :user
  belongs_to :card

  scope :by_user, ->(user_id) {
    where(user: user_id)
  }

  scope :group_by_qualities, ->() {
    joins(:card).group(:quality)
  }

  def self.delete_by_user_id(user_id)
    Print.by_user(user_id).delete_all
  end

  def self.delete_one_by_user_id(card_id, user_id)
    Print.by_user(user_id).where(card: card_id).first.destroy
  end

  def self.get_available_qualities_for_user(user_id)
    Print.by_user(user_id).group_by_qualities.select(:quality)
  end
end
