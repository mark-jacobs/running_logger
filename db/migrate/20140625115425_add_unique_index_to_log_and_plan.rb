class AddUniqueIndexToLogAndPlan < ActiveRecord::Migration
  def change
    add_index :training_plans, :plan_date, unique: true
    add_index :training_logs, :log_date, unique: true
  end
end
