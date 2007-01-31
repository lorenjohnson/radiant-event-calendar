class AddCalendarTestData < ActiveRecord::Migration
  def self.up
    Calendar.create(:name => 'Diocesan', :description => 'Diocesan Event Calendar', :ical_url => 'http://www.google.com/calendar/ical/mcbm717egpim1lumu3ipoi76t8@group.calendar.google.com/public/basic.ics')
    Calendar.create(:name => 'Cathedral', :description => 'Cathedral Events Calendar', :ical_url => 'http://www.google.com/calendar/ical/4nq6u759dndkgnbprhsofpc9r0@group.calendar.google.com/public/basic.ics')
    Calendar.create(:name => 'Bishop Visitations', :description => 'Bishop Visitations Calendar', :ical_url => 'http://www.google.com/calendar/ical/8o4iekmki3q3fk4rtneh9jkibk@group.calendar.google.com/public/basic.ics')
    Calendar.create(:name => 'Leadership Institute', :description => 'Leadership Institute Calendar', :ical_url => 'http://www.google.com/calendar/ical/totqvtet64dc6sh5rui06tmlho@group.calendar.google.com/public/basic.ics')
    Calendar.create(:name => 'Parish', :description => 'Parish Events Calendar', :ical_url => 'http://www.google.com/calendar/ical/totqvtet64dc6sh5rui06tmlho@group.calendar.google.com/public/basic.ics')
    Calendar.create(:name => 'Youth', :description => 'Youth Calendar', :ical_url => 'http://www.google.com/calendar/ical/tsr9pn0764seljjbd6mgf3i5i4@group.calendar.google.com/public/basic.ics')
    Calendar.create(:name => 'Wapiti', :description => 'Wapiti Calendar', :ical_url => 'http://www.google.com/calendar/ical/aod57olnmnne4brvlqc01d6lp8@group.calendar.google.com/public/basic.ics')
  end

  def self.down
    Calendar.delete_all
  end
end
