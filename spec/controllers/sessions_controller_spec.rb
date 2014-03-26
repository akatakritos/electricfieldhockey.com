require 'spec_helper'

describe SessionsController do

  def current_user
    User.find_by_remember_token(cookies[:remember_token])
  end
  def session_for(user)
    {
      :session => {
        :username => user.username,
        :password => user.password
      }
    }
  end

  describe 'when signed in' do
    before(:each) do
      cookies[:remember_token] = user.remember_token
    end

    let(:user) { FactoryGirl.create(:user) }

    describe 'GET #new' do
      it 'redirects to users profile' do
        get :new
        expect(response).to redirect_to(user_path(user))
      end
    end

    describe 'POST #create' do
      it 'redirects to users profile' do
        post :create
        expect(response).to redirect_to(user_path(user))
      end
    end

    describe 'DELETE #destroy' do
      it 'signs out the user' do
        post :destroy
        expect(current_user).to be_nil
      end

      it 'redirects to the root' do
        post :destroy
        expect(current_user).to redirect_to root_path
      end
    end

  end

  describe 'signing in' do
    let(:user) { FactoryGirl.create(:user) }

    describe 'POST #create' do
      describe 'successful login' do
        before(:each) do
          post :create, session_for(user)
        end

        it 'signs in the user' do
          expect(current_user).to eq(user)
        end

        it 'flashes back to the username' do
          expect(flash[:success]).to include(user.username)
        end
      end

      describe 'unsuccessful login' do
        describe 'username not found' do
          before(:each) do
            post :create, :session => { :username => 'fsdfsdg', :password => ''}
          end

          it 'errors out' do
            expect(flash.now[:error]).to_not be_nil
            expect(response).to render_template('new')
          end
        end

        describe 'bad password' do
          before(:each) do
            post :create, :session => { :username => user.username, :password => 'gdfgfdh' }
          end

          it 'errors out' do
            expect(flash.now[:error]).to_not be_nil
            expect(response).to render_template('new')
          end
        end

      end
    end
  end


end
