# class EventCalendarsController < ApplicationController
# 
#   verify :method => :post, :only => [ :destroy, :create, :update ],
#          :redirect_to => { :action => :list }
# 
#   
#   def refresh_all
#     # This is the correct line for the agent to run.  
#     # Calendar::refresh_all
#     
#     # We'll keep using this so we can keep an eye on the downlaod status until an agent and proper error checking is implemented.
#     @icals = Ical.find(:all)
#     @icals.each do |ical|
#       ical.refresh
#     end
#     flash[:notice] = "iCal subscription refresh complete."
#     redirect_to :action => "list"
#   end 
#   
#   def refresh
#     ical = Ical.find(params[:id])
#     ical.refresh
#     flash[:notice] = ical.calendar.name + " calendar subscription refreshed."
#     redirect_to :action => "list"
#   end
#   
#   def display_events
#     # days = params[:days].nil? ?  
#     calendars = params[:calendars].nil? ? Ical.find(:all).collect { |c| c.calendar.name } : params[:calendars].split(",").collect { |s| s.strip }
#     @begin_date = params[:begin_date].nil? ? Date.today : params[:begin_date]
#     @end_date = params[:end_date].nil? ? Date.today >> 6 : params[:end_date]
#     @events = Event.find(:all, :conditions => ["name IN (?) AND start_date > ? AND start_date < ?", calendars, @begin_date, @end_date], :include => :calendar, :order => "start_date ASC")
#   end
#   
#    def index
#      redirect_to :action => "list"
#    end
# 
#   def list
#     @ical_pages, @icals = paginate :icals, :per_page => 100
#   end
# 
#   def new
#     @ical = Ical.new
#   end
# 
#   def create
#     @ical = Ical.new(params[:ical])
#     if @ical.save
#       flash[:notice] = 'iCal subscription was successfully created.'
#       redirect_to :action => 'list'
#     else
#       render :action => 'new'
#     end
#   end
# 
#   def edit
#     @ical = Ical.find(params[:id])
#   end
# 
#   def update
#     @ical = Ical.find(params[:id])
#     if @ical.update_attributes(params[:ical])
#       flash[:notice] = 'iCalendar subscription was successfully updated.'
#       redirect_to :action => 'list', :id => @calendar
#     else
#       render :action => 'list'
#     end
#   end
# 
#   def destroy
#     Ical.find(params[:id]).destroy
#     redirect_to :action => 'list'
#   end
#   
#   def config
#     @icals_path = Radiant::Config.find_by_key("event_calendar.icals_path")
#     if request.post?
#       @icals_path.attributes=params[:icals_path]
#       @icals_path.save
#       # redirect_to :action => "list"
#     end
#   end
#   
# end
