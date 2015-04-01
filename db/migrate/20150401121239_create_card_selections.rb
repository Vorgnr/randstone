class CreateCardSelections < ActiveRecord::Migration
  def change
    create_table :card_selections do |t|
      t.string :values
      t.integer :deck_id

      t.timestamps null: false
    end
  end
end
