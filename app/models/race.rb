class Race < ActiveRecord::Base
  validates :user_id, presence: true
  validates :race_name, presence: true
  validates :race_date, presence: true

  belongs_to :user

end
