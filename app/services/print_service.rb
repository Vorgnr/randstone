class PrintManager
  def initialize(options = {})
    @user = options[:user]
    @deck = options[:deck]
  end

  def self.get_trio(options = {})
    if @deck.opponent_id.nil?
      is_total_must_be_clean = false
      users = @user.id
    else
      is_total_must_be_clean = true
      users = [@user.id, @deck.opponent_id]
    end

    # cards = Card.cards_to_draw(user_id: users, hero_id: @deck.hero_id)
    
    # flattened_cards = Card.flatten(cards, is_total_must_be_clean)
    # if !@deck.cards.nil?
    #   Card.remove_cards_already_in_deck(options[:cards_in_deck], flattened_cards)
    # end
    # Card.random_nuplet(3, flattened_cards.uniq)
  end

end