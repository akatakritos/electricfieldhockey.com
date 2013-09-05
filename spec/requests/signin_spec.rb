require 'spec_helper'

describe 'sign in process' do
  let(:user) { FactoryGirl.create(:user) }

  describe 'base page' do
    before { visit signin_path }

    it 'should have a login form' do
      expect(page).to have_field 'session_username'
      expect(page).to have_field 'session_password'
      expect(page).to have_button 'Sign In'
    end

    it 'should have a signup link' do
      expect(page).to have_link 'Create an account.', :href => signup_path
    end

    it_should_behave_like 'all pages'
  end

  describe 'bad info' do

    describe 'bad username' do
      before do
        visit signin_path
        fill_in 'session_username', :with => 'BAD USER NAME'
        fill_in 'session_password', :with => user.password
        click_button 'Sign In'
      end

      it 'should have a user error message' do
        expect(page).to have_selector "div.alert-error"
      end
    end

    describe 'bad password' do
      before do
        visit signin_path
        fill_in 'session_username', :with => user.username
        fill_in 'session_password', :with => "BAD PASSWORD"
        click_button 'Sign In'
      end

      it 'should have the error message' do
        expect(page).to have_selector 'div.alert-error'
      end
    end
  end
  
  describe 'valid info' do
    before do
      visit signin_path
      fill_in 'session_username', :with => user.username
      fill_in 'session_password', :with => user.password
      click_button 'Sign In'
    end

    it 'should be logged in' do
      expect(page).to have_link 'Sign Out', :href => signout_path
    end

    it 'should have a welcome message' do
      expect(page).to have_selector 'div.alert-success', "Welcome back, #{user.username}"
    end
  end

  describe 'visiting while logged in' do
    before do
      sign_in user
      visit signin_path
    end

    it 'should redirect to profile' do
      expect(page).to have_content 'Personal Details' 
    end
  end
end
