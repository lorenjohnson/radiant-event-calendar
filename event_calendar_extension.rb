class EventCalendarExtension < Radiant::Extension
  version "0.5"
  description "An event calendar extension which draws events from ical subscriptions (Google Calendar, .Mac, etc.)"
  url "http://www.hellovenado.com"

  EXT_ROOT = '/admin/event_calendar'

  define_routes do |map|
    map.resources :calendars, :path_prefix => EXT_ROOT, :collection => {:help => :get}
    map.resources :icals, :path_prefix => EXT_ROOT, :collection => {:refresh_all => :put}, :member => {:refresh => :put}
    map.resources :events, :path_prefix => EXT_ROOT
  end
  
  def activate
    admin.tabs.add "Event Calendars", EXT_ROOT + "/calendars", :after => "Layouts", :visibility => [:all]
    unless Radiant::Config["event_calendar.icals_path"]
      Radiant::Config.create(:key => "event_calendar.icals_path", :value => "icals")
    end
    EventCalendar
    EventPage
    Page.send :include, EventCalendarTags
  end

  def deactivate
    admin.tabs.remove "Event Calendars"
    # The model needs to be reloaded or some such, what to do? 
    # p.destroy if p = Radiant::Config.find_by_key("event_calendar.icals_path")
  end
end