class AddWorkoutTimeToLog < ActiveRecord::Migration
  def change
    add_column :training_logs, :log_time, :time
  end
end
