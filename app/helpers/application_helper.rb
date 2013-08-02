module ApplicationHelper

  def nav_link_to(text, url)
    link_html = "<i class='icon-chevron-right'></i> #{text}"
    class_name = current_page?(url) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to raw(link_html), url
    end
  end

  def full_title( title )
    title ? "#{title} | Electric Field Hockey" : "Electric Field Hockey"
  end

  def level_link( level )
    html = image_tag(level.json.backgroundUrl) + level.name
    link_to html, level_path(level)
  end
end
