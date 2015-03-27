class CreateHeros < ActiveRecord::Migration
  def change
    create_table :heros do |t|
      t.string :name
      t.string :class_name
      t.integer :remote_id

      t.timestamps null: false
    end
  end
end
