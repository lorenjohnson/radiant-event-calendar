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
    url = clean_url(url) if clean
    if url =~ %r{^#{ self.url }}
      self
    else
      super
    end
  end

end
