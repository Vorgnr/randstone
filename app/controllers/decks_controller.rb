class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :add_opponent]

  def index
  end

  def new
    @deck = Deck.current_users_deck(@user.id)# || @user.create_deck
    puts @deck.pretty_inspect
=begin

    if @deck.pick_opponent?
      set_opponents()
    elsif @deck.pick_hero?
      set_heroes()
    elsif @deck.hero_picked?
      @heroes = Hero.find([@deck.hero_a_id, @deck.hero_b_id, @deck.hero_c_id])
    end
=end
  end

  def add_opponent
    @deck = @user.current_deck || @user.create_deck
    puts @deck.pretty_inspect
    if @deck.update_attribute(:status, 'pick_hero')
    # if @deck.update_attributes(status: :pick_hero, :opponent_id => params[:opponent][:id])
      puts @deck.pretty_inspect
      redirect_to new_user_deck_path
    else
      puts 'paf'
    end
  end

  def add_hero
  end

  private

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