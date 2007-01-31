class EventCalendarsController < ApplicationController
  # before_filter :login_required
  # layout "admin"
  
  def refresh
    # This is the correct line for the agent to run.  
    # Calendar::refresh_all
  	
  	# We'll keep using this so we can keep an eye on the downlaod status until an agent and proper error checking is implemented.
  	@calendars = Calendar.find(:all)
  	@calendars.each do |calendar|      
  	      calendar.refresh
  	end
	end	
	
	def display_events
	  # days = params[:days].nil? ?  
	  calendars = params[:calendars].nil? ? Calendar.find(:all).collect { |c| c.name } : params[:calendars].split(",").collect { |s| s.strip }
	  @begin_date = params[:begin_date].nil? ? Date.today : params[:begin_date]
	  @end_date = params[:end_date].nil? ? Date.today >> 6 : params[:end_date]
    @events = Event.find(:all, :conditions => ["name IN (?) AND start_date > ? AND start_date < ?", calendars, @begin_date, @end_date], :include => :calendar, :order => "start_date ASC")    
  end
  
  # Scaffold generated code from here down
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @calendar_pages, @calendars = paginate :calendars, :per_page => 100
  end

  def show
    @calendar = Calendar.find(params[:id])
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    if @calendar.save
      flash[:notice] = 'Calendar was successfully created.'
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
      flash[:notice] = 'Calendar was successfully updated.'
      redirect_to :action => 'show', :id => @calendar
    else
      render :action => 'edit'
    end
  end

  def destroy
    Calendar.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end
