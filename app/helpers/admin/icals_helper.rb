module Admin::IcalsHelper 
  def calendars_for_select
    Calendar.find(:all).collect { |c| [c.name, c.id] }
  end
end