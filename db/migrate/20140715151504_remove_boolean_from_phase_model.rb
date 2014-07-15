class RemoveBooleanFromPhaseModel < ActiveRecord::Migration
  def change
    remove_column :phases, :include_phase_I
  end
end
