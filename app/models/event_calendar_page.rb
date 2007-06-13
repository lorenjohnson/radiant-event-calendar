class EventCalendarPage < Page

  description %{ Create a series of calendar pages. }

  LOGGER = ActionController::Base.logger

  def cache?
    false
  end

  def virtual?
    true
  end

  def find_by_url(url, live = true, clean = false)
    self
  end

end
