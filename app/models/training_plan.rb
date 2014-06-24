class TrainingPlan < ActiveRecord::Base
  validates :user_id, presence: true
  validates :plan_date, presence: true

  belongs_to :user
end
