require 'date'
require 'parsedate'

module EventCalendarTags
  include Radiant::Taggable
  
  desc %{  <r:calendar>...</r:calendar>
           Calendar module root node. This global tag can be used anywhere on your site or within a Event Calendar page type context. In each 
           of these two contexts the tag does a slightly different thing. In particular when in the EventCalendar page type context the calendar
           events are queried based on request parameters following the page with that type.
           
           The attributes on the calendar node itself will override any request parameters.

           <r:calendar 
              [category=""] 
              [slugs="youth|adult"] 
              [period="week(month or year)"] 
              [periods=1]
              [begin-date="5-5-2007"] 
              [end-date="7-10-2007"] >
            <r:calendar />              

            * If a begin-date is set it will use it, if an end-date is set it will be used but ignored if there is a period.name set.
  }
  tag "calendar" do |tag|    
    es = EventSearch.new
    if self.class == EventCalendar
      es.category = tag.attr['category'] || @request.parameters[:url][1] || @request.parameters["category"]
      es.slugs = tag.attr['slugs'] || @request.path_parameters[:url][2] || @request.parameters["slugs"]
      es.period.begin_date = tag.attr['begin-date'] || @request.parameters["begin-date"]
      es.period.end_date = tag.attr['end-date'] || @request.parameters["end-date"]
      es.period.amount = tag.attr['periods'] || @request.parameters["periods"].to_i
      es.period.name = tag.attr['period'] || @request.path_parameters[:url][3] || @request.parameters["period"]
    else
      es.category = tag.attr['category']
      es.slugs = tag.attr['slugs']
      es.period.amount = tag.attr['periods']
      es.period.name = tag.attr['period']
    end    
    tag.locals.event_search = es
    tag.locals.events = es.execute
    tag.locals.calendars = tag.locals.events.collect { |e| e.calendar }.uniq unless tag.locals.events.nil?
    tag.expand
  end
  
  tag "calendar:category" do |tag|
    tag.locals.event_search.category
  end

  tag "calendar:slugs" do |tag|
    # unless tag.locals.event_search.slugs.downcase == "all" || tag.locals.event_search.slugs.blank? || tag.locals.event_search.slugs.
      tag.locals.calendars.collect { |c| c.slug }.join(", ")
    # else
    #   "all"
    # end 
  end
   
  tag "calendar:names" do |tag|
    unless tag.locals.event_search.slugs.downcase == "all"
      tag.locals.calendars.collect { |c| c.name }.join(", ") unless tag.locals.calendars.nil?
    else
      "all"
    end
  end
   
  tag "calendar:period" do |tag|
    tag.locals.event_search.period
  end

  tag "calendar:periods" do |tag|
    tag.locals.event_search.period.amount
  end
  
  tag "calendar:description" do |tag|
    tag.locals.event.description
  end
    
  tag "calendar:begin_date" do |tag|
    format = tag.attr['format'].nil? ? "%d %b %y" : tag.attr['format']
    tag.locals.event_search.period.begin_date.strftime(format)
  end
   
  tag "calendar:end_date" do |tag|
    format = tag.attr['format'].nil? ? "%d %b %y" : tag.attr['format']
    tag.locals.event_search.period.end_date.strftime(format)    
  end
  
  tag "calendar:nav" do |tag|
    tag.expand
  end

  ["week","month","year"].each do |period|
    tag "calendar:nav:#{period}_link" do |tag|
      %{
        <a href="#{period}" class="#{tag.attr['class']}#{' here' if tag.locals.event_search.period == period}">
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