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
end
