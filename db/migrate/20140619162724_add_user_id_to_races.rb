class AddUserIdToRaces < ActiveRecord::Migration
  def change
    add_reference :races, :user, index: true
  end
end
