class AddReoccuranceModified < ActiveRecord::Migration
  def self.up
    add_column :events, :ical_rrule, :string, :default => ""
    add_column :events, :ical_last_modified, :string, :default => ""
  end
  def self.down
    remove_column :events, :ical_rrule
    remove_column :events, :ical_last_modified
  end
end