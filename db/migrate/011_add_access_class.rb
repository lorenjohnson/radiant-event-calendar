class AddAccessClass < ActiveRecord::Migration
  def self.up
    add_column :events, :ical_access_class, :string, :default => "public"
  end
  def self.down
    remove_column :events, :ical_access_class
  end
end