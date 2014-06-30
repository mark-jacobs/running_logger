class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :user_id
      t.datetime :log_date
      t.string :plan_workout
      t.boolean :plan_q
      t.float :plan_miles
      t.string :log_workout
      t.boolean :log_q
      t.float :log_miles
      t.time :log_time
      t.integer :log_calories
      t.string :notes

      t.timestamps
    end
  end
end
