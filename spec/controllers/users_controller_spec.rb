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

  describe 'GET new' do
    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end

  describe 'GET index' do
    before(:each) do
      users #memoize it
      get :index
    end

    let!(:users) { 
      [ FactoryGirl.create(:user), FactoryGirl.create(:user) ]
    }

    it 'sets the users' do
      expect(assigns(:users)).to eq(users)
    end
  end

  describe 'GET user' do
    before(:each) do
      get :show, :id => user.id
    end

    let(:user) { FactoryGirl.create(:user) }

    it 'sets the user' do
      expect(assigns(:user)).to eq(user)
    end
  end

end
