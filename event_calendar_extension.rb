class EventCalendarExtension < Radiant::Extension
  version "0.1"
  description "An event calendar ical subscription system."
  url "http://www.fn-group.com"
  
  define_routes do |map|
    # map.connect 'calendars/:calendar_group/:calendar/:period', :controller => 'site', :action => 'show_page', :url => 'calendars'
    map.connect 'admin/calendars/:action/:id', :controller => 'event_calendars'
  end
  
  def activate
    admin.tabs.add "Event Calendars", "/admin/calendars", :after => "Layouts", :visibility => [:all]
    unless Radiant::Config.find_by_key("event_calendar.icals_path")
      Radiant::Config.create(:key => "event_calendar.icals_path", :value => "icals")
    end
    EventCalendarRoot
    EventCalendar
    Page.send :include, EventCalendarTags
  end

  def deactivate
    admin.tabs.remove "Event Calendars"
    # Why isn't the model updated here? 
    # p.destroy if p = Radiant::Config.find_by_key("event_calendar.icals_path")
  end
end