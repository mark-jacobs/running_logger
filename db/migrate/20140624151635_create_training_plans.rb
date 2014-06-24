class CreateTrainingPlans < ActiveRecord::Migration
  def change
    create_table :training_plans do |t|
      t.datetime :plan_date
      t.float :plan_miles
      t.string :plan_workout
      t.boolean :plan_q
      t.integer :user_id

      t.timestamps
    end
  end
end
