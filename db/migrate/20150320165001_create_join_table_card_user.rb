class CreateJoinTableCardUser < ActiveRecord::Migration
  def change
    create_join_table :cards, :users do |t|
      # t.index [:user_id, :card_id]
      # t.index [:card_id, :user_id]
    end
  end
end
