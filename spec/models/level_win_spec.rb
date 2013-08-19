require 'spec_helper'

describe LevelWin do
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
