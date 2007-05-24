class EventCalendarsController < ApplicationController
  # before_filter :login_required
  # layout "admin"
  
  def refresh_all
    # This is the correct line for the agent to run.  
    # Calendar::refresh_all
  	
  	# We'll keep using this so we can keep an eye on the downlaod status until an agent and proper error checking is implemented.
  	@calendars = Calendar.find(:all)
  	@calendars.each do |calendar|      
  	      calendar.refresh
  	end
  	flash[:notice] = "Calendar subscription refresh complete."
  	redirect_to :action => "list"
	end	
	
	def refresh
    calendar = Calendar.find(params[:id])
    calendar.refresh
  	flash[:notice] = calendar.name + " calendar subscription refreshed."
    redirect_to :action => "list"
  end
  
	def display_events
	  # days = params[:days].nil? ?  
	  calendars = params[:calendars].nil? ? Calendar.find(:all).collect { |c| c.name } : params[:calendars].split(",").collect { |s| s.strip }
	  @begin_date = params[:begin_date].nil? ? Date.today : params[:begin_date]
	  @end_date = params[:end_date].nil? ? Date.today >> 6 : params[:end_date]
    @events = Event.find(:all, :conditions => ["name IN (?) AND start_date > ? AND start_date < ?", calendars, @begin_date, @end_date], :include => :calendar, :order => "start_date ASC")    
  end
  
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

   def index
     redirect_to :action => "list"
   end

  def list
    @calendar_pages, @calendars = paginate :calendars, :per_page => 100
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    if @calendar.save
      flash[:notice] = 'iCalendar subscription was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.update_attributes(params[:calendar])
      flash[:notice] = 'iCalendar subscription was successfully updated.'
      redirect_to :action => 'list', :id => @calendar
    else
      render :action => 'list'
    end
  end

  def destroy
    Calendar.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def config
    @icals_path = Radiant::Config.find_by_key("event_calendar.icals_path")
    if request.post?
      @icals_path.attributes=params[:icals_path]
      @icals_path.save
      # redirect_to :action => "list"
    end
  end
  
end
