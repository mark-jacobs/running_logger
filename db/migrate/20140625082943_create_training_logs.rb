class CreateTrainingLogs < ActiveRecord::Migration
  def change
    create_table :training_logs do |t|
      t.datetime :log_date
      t.float :log_miles
      t.string :log_workout
      t.integer :log_calories
      t.boolean :log_q
      t.text :notes
      t.integer :user_id

      t.timestamps
    end
  end
end
