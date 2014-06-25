class ChangeIndexingToHandleMultipleUsers < ActiveRecord::Migration
  def change
    remove_index :notes, :date
    remove_index :training_plans, :plan_date
    remove_index :training_logs, :log_date
    add_index :notes, [:date, :user_id], unique: true
    add_index :training_plans, [:plan_date, :user_id], unique: true
    add_index :training_logs, [:log_date, :user_id], unique: true
  end
end
