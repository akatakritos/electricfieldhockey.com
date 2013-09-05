require 'spec_helper'

describe 'authentication' do
  describe 'as guest user' do
    before do
      visit root_path
    end

    subject { page }

    it 'should have a sign in link and not a sign out link' do
      page.should have_link 'Sign In', :href => signin_path
      page.should_not have_link 'Sign Out', :href => signout_path
    end
  end

  describe 'as logged in user' do

    let(:user) { FactoryGirl.create(:user) }

    before do 
      sign_in user
      visit root_path
    end

    it 'should have a sign out path and not have a sign in link' do
      page.should have_link 'Sign Out', :href => signout_path
      page.should_not have_link 'Sign In', :href => signin_path
    end

    it 'should have a profile link' do
      page.should have_link 'Profile', :href => user_path(user)
    end
  end
end
