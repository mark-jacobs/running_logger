class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.datetime :date
      t.string :note_item
      t.integer :user_id

      t.timestamps
    end
  end
end
