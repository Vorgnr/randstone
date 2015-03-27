class CreateJoinTableCardDeck < ActiveRecord::Migration
  def change
    create_join_table :cards, :decks do |t|
      # t.index [:card_id, :deck_id]
      # t.index [:deck_id, :card_id]
    end
  end
end
