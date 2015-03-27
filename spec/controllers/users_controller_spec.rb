require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET index" do
    it "assigns @users" do
      users = User.all
      get :index
      expect(assigns(:users)).to eq(users)
    end

    it "is a success response" do
      get :index
      expect(response).to be_success
    end

    it "has a 200 http status" do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET new" do
    it "is a success response" do
      get :new
      expect(response).to be_success
    end

    it "has a 200 http status" do
      get :new
      expect(response).to have_http_status(200)
    end
  end
end
