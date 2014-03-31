require 'spec_helper'

describe Level do
  let(:level) { FactoryGirl.create(:level) }
  describe 'properties' do
    it 'has what i want' do
      expect(level).to respond_to(:id)
      expect(level).to respond_to(:name)
      expect(level).to respond_to(:json)
      expect(level).to respond_to(:created_at)
      expect(level).to respond_to(:updated_at)
      expect(level).to respond_to(:creator)
      expect(level).to respond_to(:view_count)
      expect(level).to respond_to(:level_wins)
      expect(level).to respond_to(:level_wins_count)
    end
  end

  it 'stores json as a string' do
    expect(level.json).to be_a(Hash)
    level.run_callbacks(:save) { false } # hack to only run before_save
    expect(level.json).to be_a(String)
    expect{JSON.parse(level.json)}.to_not raise_error
  end

  it 'deserializes the json string into a hash' do
    level.reload
    expect(level.json).to be_a(Hash)
  end

  describe 'featured levels' do
    describe 'newest' do
      it 'gets the newest by created_at/id' do
        one = FactoryGirl.create(:level)
        two = FactoryGirl.create(:level)
        expect(Level.newest).to eq two
      end
    end

    describe 'hardest' do
      it 'gets the one with the lowest win percent' do
        one = FactoryGirl.create(:level, :level_wins_count => 5, :view_count => 10)
        two = FactoryGirl.create(:level, :level_wins_count => 1, :view_count => 10)
        expect(Level.hardest).to eq two
      end
    end

    describe 'random' do
      it 'gets a random and excludes certain elements' do
        one = FactoryGirl.create(:level)
        two = FactoryGirl.create(:level)
        expect(Level.random(:excluding => [one])).to eq two
      end
    end
  end

end
