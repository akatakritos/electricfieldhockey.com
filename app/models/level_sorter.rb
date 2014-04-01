class LevelSorter
  LevelSorterField = Struct.new(:name, :param, :column, :default_direction)

  def initialize(params={})
    @is_default = !params.has_key?("sort")
    @params = {"sort" => "age"}.merge(params)
  end

  def possible_sorters
    @possible_sorts ||= [
      LevelSorterField.new('Age', 'age', 'created_at', 'asc'),
      LevelSorterField.new('Wins', 'wins', 'level_wins_count', 'desc'),
      LevelSorterField.new('Views', 'views', 'view_count', 'desc')
    ]
  end


  def direction
    @direction ||= decode_sort_direction
  end

  def column
    current_sorter.column
  end
  
  def name
    current_sorter.name
  end

  def default?
    @is_default
  end

  private

    def current_sorter
      @current_sorter ||= possible_sorters.find { |s| s.param == @params['sort'] }
    end

    def decode_sort_direction
      sort = @params.fetch('dir') { current_sorter.default_direction }

      if ['asc', 'desc'].include?(sort)
        sort
      else
        'asc'
      end
    end

end
