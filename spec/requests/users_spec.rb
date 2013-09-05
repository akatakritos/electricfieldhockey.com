require 'spec_helper'

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
      page.should have_content("less than a minute ago")
    end
  
    it 'should have each of the users levels' do
      user.levels.count.should eq(5)
      user.levels.all.each do |level|
        page.should have_content( level.name )
      end
    end
  end
end

