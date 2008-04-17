class Event < ActiveRecord::Base
  belongs_to :calendar
  
  def allday
    if start_date.hour == 0 && end_date.hour == 0 then
      return true
    end  
    return false
  end

  # def occurances
  #   occurances = Vpim::Rrule.new(e.start_date, e.ical_rrule)
  #   occurances.each((Date.today >> 24).to_time) do |o|
  #     
  #   end      
  # end
  # 
end
