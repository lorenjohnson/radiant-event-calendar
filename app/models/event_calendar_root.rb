class EventCalendarRoot < Page

  LOGGER = ActionController::Base.logger

  description %{ Create a series of calendar pages. }

  def cache?
    false
  end

  def page_virtual?
    true
  end

  def find_by_url(url, live = true, clean = false)
      self
  end

end
