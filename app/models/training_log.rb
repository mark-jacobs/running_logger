class TrainingLog < ActiveRecord::Base
  validates :user_id, presence: true
  validates :log_date, presence: true

  belongs_to :user
end
