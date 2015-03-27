class DecksController < ApplicationController
  before_action :set_user, only: [:index, :new, :add_opponent]

  def index
  end

  def new
    if @user.current_deck_id == nil
      @deck = Deck.create(status: "pick_opponent", user_id: @user.id)
      @user.update_attribute(:current_deck_id, @deck.id)
    else
      set_deck()
    end

    if @deck.pick_opponent?
      set_opponents()
    elsif @deck.pick_hero?
      set_heros()
    end
  end

  def add_opponent
    set_deck()
    @deck.update_attributes(:status => "pick_hero", :opponent_id => params[:opponent_id])

    respond_to do |format|
      format.json { render json: {  message: 'Opponent added', deck_status: @deck.status } }
    end
  end

  def add_hero
  end

  private
    def set_deck
      @deck = Deck.find(@user.current_deck_id)
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_heros
    end

    def set_opponents
      @opponents = User.where.not(id: @user.id)
    end
end