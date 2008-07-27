class Event < ActiveRecord::Base
  belongs_to :calendar
  # alias allday? allday
  
  def allday?
    if start_date.hour == 0 && end_date.hour == 0 then
      return true
    end  
    return false
  end

  def ical_linked?
    !ical_uid.blank?
  end

end
