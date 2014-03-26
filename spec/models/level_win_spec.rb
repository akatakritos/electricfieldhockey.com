require 'spec_helper'

describe LevelWin do
  describe 'attributes' do
    let(:level_win) { LevelWin.new }
    it 'has them' do
      expect(level_win).to respond_to(:id)
      expect(level_win).to respond_to(:level_json)
      expect(level_win).to respond_to(:game_state)
      expect(level_win).to respond_to(:attempts)
      expect(level_win).to respond_to(:time)
      expect(level_win).to respond_to(:created_at)
      expect(level_win).to respond_to(:updated_at)
      expect(level_win).to respond_to(:user)
    end
  end
  describe 'default order' do
    it 'should be sorted by attempts' do
      10.times do |i|
        LevelWin.create({
          :attempts => 10-i,
          }).save!
      end

      all_levels = LevelWin.all
      manually_sorted = LevelWin.all.sort_by { |l| l.attempts }

      all_levels.should == manually_sorted
    end
  end
end
