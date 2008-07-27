module Admin::EventsHelper

  def link_to_unless_block(condition, url, &block)
    unless condition
      concat("<a href='#{url}'>")
      yield
      concat("</a>")
    else
      yield
    end      
  end

end