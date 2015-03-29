require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:users) { 4.times.map { create(:user) } }
  let(:user) { create(:user) }

  describe '#index' do
    before(:each) { get :index }

    it 'assigns all users to @users' do
      expect(assigns(:users)).to match_array users
    end

    it 'respond with success' do
      expect(response).to be_success
    end

    it 'respond with a 200 http status' do
      expect(response).to have_http_status(200)
    end
  end

  describe '#show' do
    before(:each) { get :show, id: user.id }

    it 'respond with success' do
      expect(response).to be_success
    end

    it 'respond with a 200 http status' do
      expect(response).to have_http_status(200)
    end

    it 'assigns user' do
      expect(assigns(:user)).to eq(user)
    end
  end

  describe '#new' do
    before(:each) { get :new }

    it 'respond with success' do
      expect(response).to be_success
    end

    it 'respond with a 200 http status' do
      expect(response).to have_http_status(200)
    end

    it 'assigns new instance of user' do
      expect(assigns(:user)).to be_a User
    end
  end
end
