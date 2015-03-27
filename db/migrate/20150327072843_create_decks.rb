class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string  :name
      t.integer :class_id
      t.integer :status
      t.integer :opponent_id
      t.integer :card_a_id
      t.integer :card_b_id
      t.integer :card_c_id
      t.integer :hero_a_id
      t.integer :hero_b_id
      t.integer :hero_c_id

      t.timestamps null: false
    end
  end
end
