class UsersController < ApplicationController
  before_action :set_user, only: [:index, :show, :edit, :update, :destroy, :cards, :add_card, :delete_card, :get_cards]

  # GET /users
  # GET /users.json
  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.cards << baseCards + baseCards

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    end
  end

  def get_cards()
    puts params[:hero].empty?
    @cards = Card
      .with_name(params[:name])
      .filter_by_hero(params[:hero])
      .all_with_collection_of(@user.id, params[:limit], params[:offset])
  end

  def cards
  end

  def add_card
    @card = Card.find(params[:card_id])
    @user.cards << @card

    respond_to do |format|
      format.json { render json: {  message: 'saved' } }
    end
  end

  def delete_card
    @card = Card.find(params[:card_id])
    @user.cards.delete(@card)

    respond_to do |format|
      format.json { render json: {  message: 'deleted' } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name)
    end
end
