require 'spec_helper'

describe 'Sign Up' do

  before :each do
    visit signup_path
  end

  subject { page }
  describe 'page' do
    it 'should have the form' do
      expect(page).to have_field 'user_username'
      expect(page).to have_field 'user_password'
      expect(page).to have_field 'user_password_confirmation'
    end

    it_should_behave_like 'all pages'
  end

  describe 'error cases' do
  end

  describe 'successful cases' do
    describe 'everything provided' do

      let(:uncreated_user) { FactoryGirl.build(:user) }
      before do
        user = uncreated_user
        visit signup_path
        fill_in 'user_username', :with => user.username
        fill_in 'user_password', :with => user.password
        fill_in 'user_password_confirmation', :with => user.password_confirmation
      end

      it 'should create the user' do
        expect { click_button 'Sign Up' }.to change{ User.count }.by 1
      end

      it 'should redirect to the new users profile' do
        click_button 'Sign Up'
        page.should have_content 'Personal Details'
        page.should have_content uncreated_user.username
      end
    end
  end

  describe 'visit as logged in user' do
    let(:user) { FactoryGirl.create(:user) }

    it 'should have redirected to profile page' do
      sign_in user
      visit signin_path
      current_path.should eq user_path(user)
    end
  end
end
