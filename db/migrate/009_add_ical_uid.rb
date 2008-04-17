class AddIcalUid < ActiveRecord::Migration
  def self.up
    add_column :events, :ical_uid, :string, :default => ""
  end
  def self.down
    remove_column :events, :ical_uid
  end
end