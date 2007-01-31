class CreateCalendarAndEvents < ActiveRecord::Migration
  def self.up
    create_table :calendars do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :color, :string
    end
    create_table :events do |t|
      t.column :start_date, :datetime
      t.column :end_date, :datetime
      t.column :title, :string
      t.column :description, :text
      t.column :content_id, :integer
      t.column :report_content_id, :integer
      t.column :location, :string
      t.column :approved, :boolean
      t.column :calendar_id, :integer
    end
  end

  def self.down
    drop_table :calendars
    drop_table :events
  end
end
