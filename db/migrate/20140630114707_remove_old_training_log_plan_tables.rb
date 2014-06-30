class RemoveOldTrainingLogPlanTables < ActiveRecord::Migration
  def change
    drop_table :training_plans
    drop_table :training_logs
    drop_table :notes
  end
end
