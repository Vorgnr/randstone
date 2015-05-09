class Print < ActiveRecord::Base
  belongs_to :user
  belongs_to :card

  def self.delete_by_user_id(user_id)
    Print.where(user: user_id).delete_all
  end
end
