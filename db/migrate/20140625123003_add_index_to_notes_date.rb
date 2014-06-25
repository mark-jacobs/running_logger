class AddIndexToNotesDate < ActiveRecord::Migration
  def change
    add_index :notes, :date, unique: true
  end
end
