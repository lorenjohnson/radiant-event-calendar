class EventSearch
  attr_accessor :category, :calendars, :slugs, :period, :event_id, :event_class

  def initialize
    @period = Period.new
    @slugs = ["all"]
    @event_id = nil
    @event_class = 'all'
  end

  def event_id=(new_event_id)
    @event_id = new_event_id
  end

  def event_class=(event_class)
    unless event_class.blank?
      @event_class = event_class.downcase
    end
  end

  def slugs=(new_slugs)
    unless new_slugs.blank?
      @slugs = new_slugs.split("|").collect { |s| s.downcase }
    end
  end

  def execute
    if slugs.to_s == "all" or slugs.nil?
      events = Event.find(:all, :conditions => ["start_date BETWEEN ? AND ?", @period.begin_date, @period.end_date], :include => :calendar, :order => "start_date ASC")
    else
      events = Event.find(:all, :conditions => ["start_date BETWEEN ? AND ? AND slug IN(?)", @period.begin_date, @period.end_date, slugs], :include => :calendar, :order => "start_date ASC")
    end
    
    # Loren: Based on my testing with script/console, I don't believe that the events.find_all method 
    # will modify the events collection.
    # This was: 
    # events.find_all { |e| e.calendar.category == @category } unless @category.nil?
    # return events
    events = events.find_all { |e| e.calendar.category.downcase == @category.downcase } unless @category.nil?
    
    # Filter out the class of events if an event class of public or private is passed.
    events = events.find_all { |e| e.ical_access_class.downcase == @event_class } unless @event_class == 'all'
    
    # If an event_id was passed return only one event.  If this is a reoccurring event, select the first one
    # in the future.
    events = events.detect { |e| e.ical_uid == @event_id } unless @event_id.nil?

    return events
  end

  class Period
    attr_accessor :begin_date, :end_date, :name, :amount
    
    def initialize
      @begin_date = Date.today
      @end_date = @begin_date >> 1
      @name = "month"
      @amount = 1
      self.calculate_dates!
    end    

    def to_s
      @name
    end
    
    def begin_date=(new_begin_date)
      unless new_begin_date.blank?
        @begin_date = new_begin_date.to_date
        self.calculate_dates!
      end
    end

    def end_date=(new_end_date)
      unless new_end_date.blank?
        @end_date = new_end_date.to_date
        @name = nil
      end
    end

    def name=(new_name)
      @name = new_name
      self.calculate_dates!
    end
    
    def amount=(new_amount)
      unless new_amount.blank? || new_amount == 0
        @amount = new_amount
        self.calculate_dates!
      end
    end

    def calculate_dates!
      case @name
        when nil
        when "day"
          @end_date = @begin_date + (1 * @amount)
        when "week"
          @end_date = @begin_date + (7 * @amount)
        when "month"
          @end_date = @begin_date >> (1 * @amount)
        when "year"
          @end_date = @begin_date >> (12 * @amount)
      end
    end
  end

end