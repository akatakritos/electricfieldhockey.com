require 'spec_helper'

describe "StaticPages" do
  describe "Homepage" do

    before { visit root_path }
    it "should have the content H1 Electric Field Hockey" do
      expect(page).to have_selector('h1', 'Electric Field Hockey')
    end
  end

  describe 'sample' do
    before { visit sample_path }
    it 'should have the directions' do
      expect(page).to have_selector('h3', 'Directions')
    end

    it_should_behave_like 'all pages'
    it_should_behave_like 'game levels'
  end
end
