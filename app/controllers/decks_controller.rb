class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :add_opponent, :add_hero]
  before_action :set_deck, only: [:new, :add_opponent, :add_hero]

  def index
  end

  def new
    if @deck.pick_opponent?
      set_opponents()
    elsif @deck.pick_hero?
      set_heroes()
    elsif @deck.hero_picked?
      heroSelection = HeroSelection.find_by(deck_id: @deck.id)
      @heroes = Hero.find(heroSelection.values)
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
    raise "Hero can not be nil or empty" unless params[:hero]
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