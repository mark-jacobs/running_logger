class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.date :race_date
      t.string :race_name
      t.string :distance
      t.time :finish_time
      t.integer :position

      t.timestamps
    end
  end
end
