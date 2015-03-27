class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name
      t.integer :class_id
      t.integer :status
      t.integer :opponent_id

      t.timestamps null: false
    end
  end
end
