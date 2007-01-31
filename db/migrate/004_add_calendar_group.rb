class AddCalendarGroup < ActiveRecord::Migration
  def self.up
    add_column :calendars, :group, :string
  end

  def self.down
    remove_column :calendars, :group
  end
end
