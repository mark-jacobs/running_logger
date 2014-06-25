class Note < ActiveRecord::Base
  validates :date, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
end
