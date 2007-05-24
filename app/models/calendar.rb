require 'rubygems' 
require 'net/http'
require_gem 'vpim'
require 'date'

class Calendar < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  validates_presence_of :ical_url
  validates_presence_of :name
  validates_presence_of :group
  # validates_presence_of :slug

	@@calendars_path = "public/assets/calendars/"

  def to_s
    self.name
  end
  
	# Download and save the .ics calendar file, parse and save to database
	def refresh
    ical_filename = @@calendars_path + name + ".ics"

    # Retrieve calendar specified by URL and Name attributes
    response = Net::HTTP.get_response(URI.parse(ical_url))

  	File.open(ical_filename, "w") { |file|
      file << response.body
    }
    
    # Erase all existing entries for target calendar
    # I can't use a delete_all here, but this is a depedent model so this hack works. Look into how to do this properly later.
    self.events = []
    self.save

    # Open file for reading, parse and store to DB
    begin
      File.open(ical_filename, "r") { |file|
        cal = Vpim::Icalendar.decode(file).first
        # Calendar.find(:first, :conditions => "name = '" << @cal.properties["x-wr_calname"]  << "'")
        event_count = 0
        cal.components.each do |parsed_event|
          # Implement a CalendarConfig model to handle total # of months and frequency of event capture 
          parsed_event.occurences.each((Date.today >> 24).to_time) do |o|
            new_event = Event.new
            new_event.start_date = o
            new_event.end_date = Time.local(o.year, o.month, o.day, parsed_event.dtend.hour, parsed_event.dtend.min)
            new_event.title = parsed_event.summary
            new_event.description = parsed_event.description        
            new_event.location = parsed_event.location        
            new_event.calendar = self
            new_event.save
            event_count = event_count + 1
          end
        end  
        self.last_refresh_count = event_count
        self.last_refresh_date = Time.now
        self.save
        logger.info self.group + "/" + self.slug + " - iCalendar subscription refreshed on " + Time.now.strftime("%m/%d at %H:%M")
      }      
    rescue
      logger.info ical_filename << " -- error."
      return
    end
	end
	
	def Calendar.refresh_all
  	find(:all).each do |c|
  	  c.refresh
  	end
  	return true
	end

end
