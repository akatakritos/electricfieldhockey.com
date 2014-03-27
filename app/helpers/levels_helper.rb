module LevelsHelper

#<div class='btn-group'>
  #<a class='btn' href='/levels/?sort=age'>Age</a>
  #<a class='btn active' href='/levels/?sort=wins'>Wins</a>
  #<a class='btn' href='/levels/?sort=views'>Views</a>
#</div>
  def sorter_block(sorter, opts = {})
    css = "btn-group " + opts.fetch(:class) { '' }
    content_tag(:div, :class => css) do
      sorter_content(sorter)
    end
  end

  private
    def sorter_content(sorter)
      sorter.possible_sorters.map do |s|
        css = "btn"
        css += " active" if sorter.column == s.column
        link_to s.name, 
          params.merge("sort" => s.param), 
          :class => css
      end.join.html_safe
    end

end
