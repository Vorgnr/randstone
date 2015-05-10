class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :show, :add_hero, :add_card]
  before_action :set_deck, only: [:new, :add_hero, :add_card]

  def index
    @decks = Deck.user_completed_decks(@user.id)
  end

  def show
    @deck = Deck.find(params[:id])
    set_mana_curve
  end

  def new
    if @deck.pick_hero?
      set_heroes
    elsif @deck.hero_picked?
      hero_selection = HeroSelection.find_by(deck_id: @deck.id)
      @heroes = Hero.find(hero_selection.values)
    elsif @deck.pick_cards?
      card_selection = @deck.current_cards_selection
      if !card_selection.nil?
        @cards = Card.find(card_selection.values)
      else
        quality = Card.random_quality(Print.get_available_qualities_for_user(@user.id))
        filtered_cards = @user.cards_to_draw.with_qualities(quality)
        @cards = Card.random_nuplet(3, filtered_cards.uniq.to_a)
        @deck.create_card_selection(@cards.map { |c| c.id })
      end
      set_mana_curve
    end
  end

  def set_mana_curve
    card_count = @deck.cards.length
    @card_with_count = Hash.new(0)
    card_count_by_cost = Hash.new(0)
    @mana_curve = Hash.new(0)
    ordered_cards = @deck.cards.order(:cost)
    ordered_cards.each do |v| 
      @card_with_count[v] +=1
      index = v.cost
      if v.cost >= 7
        index = 7
      end
      card_count_by_cost[index] += 1
    end
    card_count_by_cost.each do |cost, count|
      @mana_curve[cost] = { 
        rate: (count.to_f / card_count.to_f) * 100, 
        count: card_count_by_cost[cost] }
    end
  end

  def add_card
    raise "Unexpected deck's status" unless @deck.pick_cards?
    raise 'Card can not be nil or empty' if !params[:card] || params[:card] == ''
    card = Card.find(params[:card])
    @deck.add_card(card)
    redirect_to (@deck.completed?) ? decks_path : new_deck_path
  end

  def add_hero
    raise "Unexpected deck's status" unless @deck.hero_picked?
    raise 'Hero can not be nil or empty' if !params[:hero] || params[:hero] == ''
    if @deck.set_hero(params[:hero])
      @user.set_cards_to_draw_for_current_deck(params[:hero])
      redirect_to new_deck_path
    end
  end

  private
    def set_user
      @user = current_user
    end

    def set_deck
      @deck = @user.current_deck || @user.create_deck
    end

    def set_heroes
      @heroes = Hero.random_trio
      raise 'Not enough heroes in data base' unless @heroes.all? { |h| h.is_a? Hero }
      @deck.pick_heroes(@heroes)
    end
end