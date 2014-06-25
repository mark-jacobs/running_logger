class RemoveNotesFromTrainingLogs < ActiveRecord::Migration
  def change
    remove_column :training_logs, :notes
  end
end
