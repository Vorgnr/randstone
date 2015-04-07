class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :show, :add_opponent, :add_hero, :add_card]
  before_action :set_deck, only: [:new, :add_opponent, :add_hero, :add_card]

  def index
    @decks = Deck.users_deck(@user.id)
  end

  def show
    @deck = Deck.find(params[:id])
  end

  def new
    if @deck.pick_opponent?
      set_opponents
    elsif @deck.pick_hero?
      set_heroes
    elsif @deck.hero_picked?
      hero_selection = HeroSelection.find_by(deck_id: @deck.id)
      @heroes = Hero.find(hero_selection.values)
    elsif @deck.pick_cards?
      card_selection = @deck.current_cards_selection
      if !card_selection.nil?
        @cards = Card.find(card_selection.values)
      else
        @cards = Card.get_trio(user_id: @user.id, opponent_id: @deck.opponent_id, hero_id: @deck.hero_id, cards_in_deck: @deck.cards)
        @deck.create_card_selection(@cards.map { |c| c.id })
      end
    else
      redirect_to user_decks_path
    end
  end

  def add_card
    raise "Unexpected deck's status" unless @deck.pick_cards?
    raise 'Card can not be nil or empty' if !params[:card] || params[:card] == ''
    card = Card.find(params[:card])
    @deck.add_card(card)
    redirect_to new_deck_path
  end

  def add_opponent
    raise "Unexpected deck's status" unless @deck.pick_opponent?
    if @deck.set_opponent(params[:opponent][:id])
      redirect_to new_deck_path
    end
  end

  def add_hero
    raise "Unexpected deck's status" unless @deck.hero_picked?
    raise 'Hero can not be nil or empty' if !params[:hero] || params[:hero] == ''
    if @deck.set_hero(params[:hero])
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

    def set_opponents
      @opponents = User.where.not(id: @user.id)
    end

    def set_heroes
      @heroes = Hero.random_trio
      raise 'Not enough heroes in data base' unless @heroes.all? { |h| h.is_a? Hero }
      @deck.pick_heroes(@heroes)
    end
end