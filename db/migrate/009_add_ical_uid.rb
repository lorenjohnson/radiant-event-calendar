class AddIcalUid < ActiveRecord::Migration
  def self.up
    add_column :events, :ical_uid, :string, :default => ""
    
    # For this version name of the class has changed from EventCalendarPage to EventCalendar
    execute "update pages set class_name = 'EventCalendar'  where class_name = 'EventCalendarPage'"
  end
  def self.down
    remove_column :events, :ical_uid
    execute "update pages set class_name = 'EventCalendarPage'  where class_name = 'EventCalendar'"
  end
end