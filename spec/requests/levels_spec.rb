require 'spec_helper'

describe "LevelsSpecs" do
  describe 'Levels Index' do
    before do
      level1 = FactoryGirl.create(:level)
      level2 = FactoryGirl.create(:level)
      visit levels_path
    end

    subject { page }

    it 'has h1 Levels' do
      page.should have_selector('h1', 'Levels')
    end

    it 'should list all the details about each level' do
      Level.all.each do |l|
        page.should have_selector('h5', l.name)
        page.should have_link(l.creator.username, :href => user_path(l.creator))
        page.should have_link('Scoreboard', :href => level_scoreboard_path(l))
      end
    end

    it 'should have new level link' do
      page.should have_link('New Level', new_level_path)
    end

    it_should_behave_like 'all pages'
  end

  describe 'New Level' do
    describe 'as unauthorized user' do
      it 'should redirect to login' do
        visit new_level_path
        expect(page).to have_content('Please sign in')
      end
    end

    describe 'as logged in user' do
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do
        sign_in user
        visit new_level_path
      end

      subject { page }

      it 'should present the form' do
        page.should have_selector('h1', 'New level')
      end

      it_should_behave_like 'all pages'
    end
  end
end
