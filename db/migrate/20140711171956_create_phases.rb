class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.datetime :start_date
      t.datetime :target_date
      t.integer :user_id
      t.boolean :include_phase_I

      t.timestamps
    end
  end
end
