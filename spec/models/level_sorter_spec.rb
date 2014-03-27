require 'spec_helper'

describe LevelSorter do
  describe 'sort fields' do
    let(:sorter) { LevelSorter.new }
    it 'gets a list of potential sort fields' do
      expect(sorter.possible_sorters).to have_at_least(1).items
    end

    it 'should return a list that each have a name, field,column, and default_direction' do
      sorter.possible_sorters.each do |field|
        expect(field).to respond_to(:name)
        expect(field).to respond_to(:column)
        expect(field).to respond_to(:param)
        expect(field).to respond_to(:default_direction)
      end
    end

  end

  describe 'current sort' do
    it 'gets the sort field from params' do
      sorter = LevelSorter.new( "sort" => "age")
      expect(sorter.column).to eq "created_at"

      sorter = LevelSorter.new("sort" => "wins")
      expect(sorter.column).to eq "level_wins_count"
    end

    it 'gets the current direction from the params' do
      sorter = LevelSorter.new("sort" => "wins", "dir" => "desc")
      expect(sorter.direction).to eq("desc")
    end

    it 'defaults to age, asc if no params' do
      sorter = LevelSorter.new
      expect(sorter.name).to eq "Age"
      expect(sorter.direction).to eq "asc"
    end

  end
end
