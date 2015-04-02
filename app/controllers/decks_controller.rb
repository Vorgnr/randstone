class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :add_opponent, :add_hero]
  before_action :set_deck, only: [:new, :add_opponent, :add_hero]

  def index
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
        cards = card_selection.values
      else
        # Todo Generate cards
        cards = [36, 9, 22]
        @deck.create_card_selection(@cards)
      end
      @cards = cards
    end
  end

  def add_opponent
    raise "Unexpected deck's status" unless @deck.pick_opponent?
    if @deck.set_opponent(params[:opponent][:id])
      redirect_to new_user_deck_path
    end
  end

  def add_hero
    raise "Unexpected deck's status" unless @deck.hero_picked?
    raise 'Hero can not be nil or empty' if !params[:hero] || params[:hero] == ''
    if @deck.set_hero(params[:hero])
      redirect_to new_user_deck_path
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
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