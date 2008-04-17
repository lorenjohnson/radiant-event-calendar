class EventPage < Page

  LOGGER = ActionController::Base.logger

  description %{ The root page for displaying individual events. }

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
