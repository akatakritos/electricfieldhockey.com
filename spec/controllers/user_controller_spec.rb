require 'spec_helper'

describe UsersController do
  describe 'POST create' do

    it 'creates a new user' do
      expect do
        post :create, :user => FactoryGirl.attributes_for(:user)
      end.to change{User.count}.by(1)
    end

    it 'signs the user in' do
      post :create, :user => FactoryGirl.attributes_for(:user)
      expect(flash[:success]).to match /Welcome/
    end

    it 'redirects to the users page' do
      post :create, :user => FactoryGirl.attributes_for(:user)
      expect(response).to redirect_to user_path(assigns(:user))
    end

  end

end
