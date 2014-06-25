class TrainingLog < ActiveRecord::Base
  validates :user_id, presence: true
  validates :log_date, presence: true, uniqueness: { scope: :user_id, 
        message: "Only one session can be planned for a day." }

  belongs_to :user
end
