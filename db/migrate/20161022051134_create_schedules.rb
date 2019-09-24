class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.datetime :scheduled_at
      t.string :identifier, index: true, unique: true
      t.string :recurrence_interval
      t.integer :rety_count, default: 0
      t.string :status, default: "inactive"
      t.jsonb :metadata
      t.belongs_to :subscription, foreign_key: true

      t.timestamps
    end
  end
end
