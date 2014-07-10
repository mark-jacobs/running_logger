class Log < ActiveRecord::Base
  validates :log_date, presence: true, uniqueness: { scope: :user_id, 
        message: "Only one session can be planned for a day." }
  validates :plan_miles, :inclusion => { :in => 0..100, message: ", range of 1 to 100 miles only"}, 
            numericality: true, allow_nil: true
  validates :log_miles, :inclusion => { :in => 0..100, message: ", range of 1 to 100 miles only"}, 
            numericality: true, allow_nil: true
  belongs_to :user
end
