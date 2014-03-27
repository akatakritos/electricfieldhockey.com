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

  describe 'Levels index pagination' do
    describe 'with more than 10 items' do
      before do
        15.times { FactoryGirl.create(:level) }
      end

      it 'should paginate to 10 levels' do
        visit levels_path
        expect(page).to have_selector('div.pagination')
        expect(page).to have_selector('div.pagination li', '1')
        expect(page).to have_selector('div.pagination li', '2')
      end
    end

    describe 'with less than 10 items' do
      it 'should not show the pagination block' do
        visit levels_path
        expect(page).to_not have_selector('div.pagination')
      end
    end
  end

  describe 'Level index sorting' do
    before { visit levels_path }
    it 'should be sortable by age' do
      expect(page).to have_selector('.btn-group a', 'Age')
    end

    it 'should be sortable by wins' do
      expect(page).to have_selector('.btn-group a', 'Wins')
    end

    it 'should be sortable by views' do
      expect(page).to have_selector('.btn-group a', 'Views')
    end
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
