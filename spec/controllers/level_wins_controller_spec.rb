require 'spec_helper'

describe LevelWinsController do
  describe 'GET show' do
    let(:level_win) { FactoryGirl.create(:level_win) }
    it 'sets the level_win' do
      get :show, :id => level_win.id

      expect(assigns(:level_win)).to eq(level_win)
    end

    it 'sets the level to the level_wins owner' do
      get :show, :id => level_win.id
      expect(assigns(:level)).to eq(level_win.level)
    end
  end

  describe 'POST #create' do
    describe 'when signed in' do
      before(:each) do
        sign_in user
      end
      
      let(:user) { FactoryGirl.create(:user) }

      it 'sets the levels user to the current user' do
        post :create, FactoryGirl.attributes_for(:level)
        expect(assigns(:level).user).to eq(user)
      end

      it 'saves the level' do
        post :create, FactoryGirl.attributes_for(:level)
        expect(assigns(:level)).to_not be_new_record
      end
    end

    describe 'as a guest user' do
      it 'saves and assigns' do
        post :create, FactoryGirl.attributes_for(:level)
        expect(assigns(:level)).to_not be_new_record
      end

      it 'should respond with 200 OK' do
        response.status.should == 200
      end
    end
  end
end
