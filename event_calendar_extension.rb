class EventCalendarExtension < Radiant::Extension
  version "0.6"
  description "An event calendar extension which draws events from any ical publishers (Google Calendar, .Mac, etc.)"
  url "http://www.hellovenado.com"

  EXT_ROOT = '/admin/event_calendar'

  define_routes do |map|
    map.resources :calendars, :path_prefix => EXT_ROOT, :collection => {:help => :get}
    map.resources :icals, :path_prefix => EXT_ROOT, :collection => {:refresh_all => :put}, :member => {:refresh => :put}
    map.resources :events, :path_prefix => EXT_ROOT
  end
  
  def activate
    EventCalendarPage
    admin.tabs.add "Event Calendars", EXT_ROOT + "/calendars", :after => "Snippets", :visibility => [:all]
    unless Radiant::Config["event_calendar.icals_path"]
      Radiant::Config.create(:key => "event_calendar.icals_path", :value => "icals")
    end
    Page.send :include, EventCalendarTags
  end

  def deactivate
    # Please remove this extension from the vendor/extension directory and restart web server to deactivate this extensions
  end
end
