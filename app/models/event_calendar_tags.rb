require 'date'
require 'parsedate'

module EventCalendarTags
  include Radiant::Taggable
  
  desc %{  <r:calendar>...</r:calendar>
           Calendar module root node. }
  tag "calendar" do |tag|
    tag.locals.calendar_group = tag.attr['group'] || (@request.parameters[:url][1] if self.class == EventCalendar) || "master"
    tag.locals.calendars = tag.attr['calendars'] || (@request.path_parameters[:url][2] if self.class == EventCalendar) || "all"
    tag.locals.period = tag.attr['period'] || (@request.path_parameters[:url][3] if self.class == EventCalendar) || "month"
    tag.locals.calendars = "all" if tag.locals.calendars.nil?
    tag.locals.begin_date = Date.today

    case tag.locals.period
      when "week"
        tag.locals.end_date = tag.locals.begin_date + 7  
      when "weeks"
        tag.locals.end_date = tag.locals.begin_date + (7 * tag.locals.period_amount.to_i)      
      when "month"
        tag.locals.end_date = tag.locals.begin_date >> 1
      when "months"
        tag.locals.end_date = tag.locals.begin_date >> tag.locals.period_amount.to_i        
      when "year"
        tag.locals.end_date = tag.locals.begin_date >> 12
      else
        tag.locals.end_date = tag.locals.begin_date >> 1
    end
     
    if tag.locals.calendars.downcase == "all" 
      tag.locals.events = Event.find(:all, :conditions => ["`group` = ? AND start_date BETWEEN ? AND ?", tag.locals.calendar_group, tag.locals.begin_date, tag.locals.end_date], :include => :calendar, :order => "start_date ASC")
    else
      tag.locals.events = Event.find(:all, :conditions => ["`group` = ? AND start_date BETWEEN ? AND ? AND slug = ?", tag.locals.calendar_group, tag.locals.begin_date, tag.locals.end_date, tag.locals.calendars.to_s], :include => :calendar, :order => "start_date ASC")
    end
    tag.locals.calendar = Calendar.find(:first, :conditions => ["`group` = ? AND slug = ?", tag.locals.calendar_group, tag.locals.calendars])
    tag.expand
  end
  
  tag "calendar:calendar_group" do |tag|
    tag.locals.calendar_group
  end

  tag "calendar:name" do |tag|
    if tag.locals.calendars.downcase == "all"
      "all"
    else
      tag.locals.calendar.name 
    end 
  end
   
  tag "calendar:period" do |tag|
    tag.locals.period
  end
  
  tag "calendar:slug" do |tag|
    if tag.locals.calendars.downcase == "all"
      "all"
    else
      tag.locals.calendar.slug
    end
  end
   
  tag "calendar:description" do |tag|
    tag.locals.event.description
  end
    
  tag "calendar:begin_date" do |tag|
    format = tag.attr['format'].nil? ? "%d %b %y" : tag.attr['format']
    tag.locals.begin_date.strftime(format)
  end
   
  tag "calendar:end_date" do |tag|
    format = tag.attr['format'].nil? ? "%d %b %y" : tag.attr['format']
    tag.locals.end_date.strftime(format)    
  end
  
  tag "calendar:nav" do |tag|
    tag.expand
  end

  ["week","month","year"].each do |period|
    tag "calendar:nav:#{period}_link" do |tag|
      %{
        <a href="#{period}" class="#{tag.attr['class']}#{' here' if tag.locals.period == period}">
          #{tag.expand.blank? ? period : tag.expand }
        </a>
      }
    end
  end
  
  tag "calendar:event" do |tag|      
    tag.expand
  end
  
  tag "calendar:event:each" do |tag|
    events = tag.locals.events
    content = ''
    # To prime the header tag as per page_context page:children:each:header code...
    tag.locals.previous_headers = {}
    if tag.locals.events.length > 0 
      tag.locals.events.each do |event|
        tag.locals.event = event
        content << tag.expand
      end
    else
      content = "No events found."
    end
    content
  end
  
  tag 'calendar:event:each:header' do |tag|
    previous_headers = tag.locals.previous_headers
    name = tag.attr['name'] || :unnamed
    restart = (tag.attr['restart'] || '').split(';')
    header = tag.expand
    unless header == previous_headers[name]
      previous_headers[name] = header
      unless restart.empty?
        restart.each do |n|
          previous_headers[n] = nil
        end
      end
      header
    end
  end
   
  tag "calendar:event:each:calendar_name" do |tag|
    tag.locals.event.calendar.name
  end
   
  tag "calendar:event:each:id" do |tag|
    tag.locals.event.id
  end
   
  tag "calendar:event:each:calendar_description" do |tag|
    tag.locals.event.calendar.description
  end
   
  tag "calendar:event:each:calendar_color" do |tag|
    tag.locals.event.calendar.color
  end
   
  tag "calendar:event:each:title" do |tag|
    tag.locals.event.title
  end
   
  tag "calendar:event:each:description" do |tag|
    tag.locals.event.description
  end
   
  tag "calendar:event:each:location" do |tag|
    tag.locals.event.location
  end
   
  tag "calendar:event:each:timeperiod" do |tag|
    if tag.locals.event.allday then
      timeperiod = "All Day"
    else
      timeperiod = tag.locals.event.start_date.strftime(tag.attr['format']) << " - " << tag.locals.event.end_date.strftime(tag.attr['format'])
    end
    timeperiod 
  end
   
  tag "calendar:event:each:daterange" do |tag|
    if tag.locals.event.start_date.strftime("%x") == tag.locals.event.end_date.strftime("%x") then
      daterange = tag.locals.event.start_date.strftime(tag.attr['format'])
    else
      daterange = tag.locals.event.start_date.strftime(tag.attr['format']) << (tag.attr["separator"] || " - ") << tag.locals.event.end_date.strftime(tag.attr['format'])
    end
    daterange
  end
   
  tag "calendar:event:each:start" do |tag|
    start_date = tag.locals.event.start_date.strftime(tag.attr['format'])
  end
   
  tag "calendar:event:each:end" do |tag|
    end_date = tag.locals.event.end_date.strftime(tag.attr['format'])
  end
end