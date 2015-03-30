class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :add_opponent]

  def index
  end

  def new
    if !@user.has_pending_deck?
      @deck = @user.create_deck
    else
      set_deck()
    end

    if @deck.pick_opponent?
      set_opponents()
    elsif @deck.pick_hero?
      set_heroes()
    elsif @deck.hero_picked?
      @heroes = Hero.find([@deck.hero_a_id, @deck.hero_b_id, @deck.hero_c_id])
    end
  end

  def add_opponent
    set_deck()
    puts @user.inspect
    puts @deck.inspect
    @deck.update_attributes(:status => 'pick_hero', :opponent_id => params[:opponent][:id])

    respond_to do |format|
      format.html { redirect_to new_user_deck_path }
      format.json { render json: {  message: 'Opponent added', deck_status: @deck.status } }
    end
  end

  def add_hero
  end

  private
    def set_deck
      @deck = @user.current_deck
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_opponents
      @opponents = User.where.not(id: @user.id)
    end

    def set_heroes
      @heroes = Hero.all
      @deck.pick_heroes(@heroes[0].id, @heroes[1].id, @heroes[2].id)
    end

    def random_heroes(heroes)
      heroes = heroes.shuffle
      return [heroes[0], heroes[1], heroes[3]]
    end
end