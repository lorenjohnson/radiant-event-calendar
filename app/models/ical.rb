require 'rubygems' 
require 'net/http'
require 'vpim'
require 'date'

class Ical < ActiveRecord::Base
  belongs_to :calendar
  validates_presence_of :ical_url

  @@admin_calendars_path = Radiant::Config["event_calendar.icals_path"]
  
  def refresh
    ical_filename = RAILS_ROOT + "/public/" + @@admin_calendars_path + "/" + self.calendar.slug + ".ics"
    begin
      response = Net::HTTP.get_response(URI.parse(ical_url)) 

      File.open(ical_filename, "w") { |file|
        file << response.body
      }
    rescue 
      logger.error "iCal url or file error with: #{self.calendar.name} - #{ical_url} (#{ical_filename}) -- error."
      return false
    end 
    
    File.open(ical_filename, "r") do |file|
      cal = Vpim::Icalendar.decode(file).first
      event_count = 0
      cal.components.each do |parsed_event|
        # Destroy any iCal events which are not longer in the iCal feed
        existing_uids = parsed_event.occurences.collect { |e| e.uid }
        self.calendar.events.find(:all, :conditions => ["ical_uid <> '' AND ical_uid NOT IN ?", existing_uids]).each { |e| e.destroy }    
        
        # 24 below is a setting which is telling VPIM to only parse up to that many # of months for reoccurences,
        # Could be moved to a Radiant::Config['event_calendar.ical_months']   
        parsed_event.occurences.each((Date.today >> 24).to_time) do |o|
          event = Event.find_or_initialize_by_ical_uid(parsed_event.uid)
          event.calendar = self.calendar
          event.ical_last_modified = parsed_event.lastmod
          event.ical_rrule = parsed_event.propvalue('RRULE')
          event.start_date = o
          event.end_date = Time.local(o.year, o.month, o.day, parsed_event.dtend.hour, parsed_event.dtend.min)
          event.title = parsed_event.summary
          event.description = parsed_event.description
          event.location = parsed_event.location
          event.save
          event_count = event_count + 1
        end
      end  
      self.last_refresh_count = event_count
      self.last_refresh_date = Time.now
      self.save
      logger.info self.calendar.category + "/" + self.calendar.name + " - iCalendar subscription refreshed on " + Time.now.strftime("%m/%d at %H:%M")
    end 
  end
  
  def self.refresh_all
    find(:all).each do |i|
      i.refresh
    end
    return true
  end
  
end