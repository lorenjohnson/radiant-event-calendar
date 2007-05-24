class EventCalendar < Page

  LOGGER = ActionController::Base.logger

  description %{ Allow event calendars (multiple ok) to be put anywhere on this page. }

  # def cache?
  #   false
  # end

  # def page_virtual?
  #   true
  # end
  # 
  # def find_by_url(url, live = true, clean = false)
  #   if tag.locals.page
  #     self
  #   else
  #     super
  #   end
  # end

end
