class EventCalendarExtension < Radiant::Extension
  version "0.7"
  description "An event calendar extension which draws events from any ical publishers (Google Calendar, .Mac, etc.)"
  url "http://www.hellovenado.com"

  define_routes do |map|
    map.namespace :admin do |admin|
      admin.resources :events
      admin.resources :calendars, 
        :collection => {:help => :get}
      admin.resources :icals, 
        :collection => {:refresh_all => :put}, 
        :member => {:refresh => :put}
    end
  end
  
  def activate
    admin.tabs.add "Event Calendars", "admin/calendars", :after => "Layouts", :visibility => [:all]
    unless Radiant::Config["event_calendar.icals_path"]
      Radiant::Config.create(:key => "event_calendar.icals_path", :value => "icals")
    end
    EventCalendar
    EventPage
    Page.send :include, EventCalendarTags
  end

  def deactivate
    admin.tabs.remove "Event Calendars"
  end
end
