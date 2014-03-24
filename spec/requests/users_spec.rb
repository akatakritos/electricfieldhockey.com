require 'spec_helper'
include ActionView::Helpers::DateHelper

describe "Users Specs" do
  describe "Profile View" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      5.times do
        level = FactoryGirl.build(:level)
        level.creator = user
        level.save!
      end
      visit user_path(user)
    end

    subject { page }
    
    it 'should have h3 personal details' do
      page.should have_selector('h3', 'Personal Details')
    end

    it 'should have the users username' do
      page.should have_content(user.username)
    end

    it 'should have the users member since time' do
      page.should have_content(time_ago_in_words(user.created_at))
    end

    it 'should have each of the users levels' do
      user.levels.count.should eq(5)
      user.levels.all.each do |level|
        page.should have_content( level.name )
      end
    end

    describe 'as a guest' do

      it 'should not have edit links for the level' do
        user.levels.each do |level|
          page.should_not have_link 'Edit', :href => edit_level_path(level)
        end
      end
    end

    describe 'as a different user' do
      let(:different_user) { FactoryGirl.create(:user) }
      before do
        sign_in different_user
      end

      it 'should not have edit links for the level' do
        user.levels.each do |level|
          page.should_not have_link 'Edit', :href => edit_level_path(level)
        end
      end
    end

    describe 'as the user himself' do
      before do
        sign_in user
      end

      it 'should not have edit links' do
        user.levels.each do |level|
          page.should_not have_link 'Edit', :href => edit_level_path(level)
        end
      end
    end

    it_should_behave_like 'all pages'
  end

  describe 'index view' do
    before do
      20.times do 
        FactoryGirl.create(:user)
      end

      visit users_path
    end

    subject { page }

    it 'should list all the users usernames and names and member since' do
      User.all.each do |user|
        page.should have_selector "tr#user-#{user.id} td", user.name
        page.should have_selector "tr#user-#{user.id} td", user.username
        page.should have_selector "tr#user-#{user.id} td", time_ago_in_words(user.created_at)
      end
    end

    it 'should link to the users profile by username' do
      User.all.each do |user|
        page.should have_link user.username, :href => user_path(user)
      end
    end
    
    it_should_behave_like 'all pages'
  end
end

