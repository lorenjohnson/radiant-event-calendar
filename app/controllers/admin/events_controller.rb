class Admin::EventsController < ApplicationController
  
  def index
    es = EventSearch.new
    es.period.amount = 6
    @events = Event.find(:all)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @events.to_xml }
    end
  end

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.xml  { render :xml => @event.to_xml }
    end
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to admin_events_path }
        format.xml  { head :created }
        # , :location => event_url(@event) 
        format.js { @status = flash[:notice] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    @status = "test"
    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to admin_events_path }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.xml  { head :ok }
    end
  end
end
