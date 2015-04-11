class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :set
      t.integer :quality
      t.integer :type_id
      t.integer :cost
      t.integer :health
      t.integer :attack
      t.integer :faction
      t.integer :hero_id
      t.integer :elite
      t.integer :collectible
      t.string :name
      t.string :description
      t.integer :popularity
      t.string :image

      t.timestamps null: false
    end
  end
end
