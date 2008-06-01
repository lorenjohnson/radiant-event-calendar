require File.dirname(__FILE__) + "/../spec_helper"

describe Event do
  before :each do
    @event = Event.new
  end
  
  it "should be all day if it starts and ends at midnight" do
    @event.start_date = @event.end_date = Time.now.beginning_of_day
    @event.should be_allday
  end
  
  it "should not be all day if it starts and ends at different times" do
    @event.end_date = Time.now.beginning_of_day
    @event.start_date = Time.now.end_of_day
    @event.should_not be_allday
  end
  
end