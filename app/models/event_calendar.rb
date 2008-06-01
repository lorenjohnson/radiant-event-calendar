class EventCalendar < Page

  LOGGER = ActionController::Base.logger

  description %{ Create a series of calendar pages. }

  def cache?
    false
  end

  def virtual?
    true
  end

  def find_by_url(url, live = true, clean = false)
    # cat = @request.parameters[:url][1] || @request.parameters["category"]
    # if cat == "event"
    #   id = @request.parameters[:url][2] || @request.parameters["event_id"]
    #   children.each do |child|
    #     # from console test to see what child.find_by_url does on EventCalendar virtual node.... by pass to Page.find(:all,:conditions => "url = ?", ... )?
    #     # event_link tags... <a href="/calendar/event/102"></a>
    #     event_root = child.find_by_url("event", live, clean)
    #   end
    # else
      self
    # end
  end

end
