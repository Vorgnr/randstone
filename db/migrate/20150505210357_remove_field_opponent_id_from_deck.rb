class RemoveFieldOpponentIdFromDeck < ActiveRecord::Migration
  def change
    remove_column :decks, :opponent_id, :integer
  end
end
