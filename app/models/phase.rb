class Phase < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :start_date, presence: true 
  validates :target_date, presence: true
  validate :range_cannot_be_covered_by_other_phase
  validate :start_date_must_be_earlier_than_target_date

  before_validation :adjust_dates_to_whole_weeks

  def range_cannot_be_covered_by_other_phase
    if id.nil?
      phases = Phase.where("user_id = ? ", user_id)
    else
      phases = Phase.where("user_id = ? AND id <> ?", user_id, id)
    end
    unless phases.nil?
      phases.each do |each_phase|
        if start_date >= each_phase.start_date && start_date <= each_phase.target_date
          errors.add(:start_date, "overlaps another training period.")
        end
        if target_date >= each_phase.start_date && target_date <= each_phase.target_date
          errors.add(:target_date, "overlaps another training period.")
        end
        if start_date <= each_phase.start_date && target_date >= each_phase.target_date
          errors.add(:start_date, "overlaps another training period.")
          errors.add(:target_date, "overlaps another training period.")
        end
      end
    end
      # errors.add(:target_date, "test error")
  end

  def start_date_must_be_earlier_than_target_date
    if target_date.to_i <= start_date.to_i
      errors.add(:target_date, "is earlier than the start date")
    end
  end

  private

    def adjust_dates_to_whole_weeks
      if self.start_date.wday == 0
        start_adjust_day = 7
      else 
        start_adjust_day = self.start_date.wday
      end
      self.start_date = self.start_date - start_adjust_day.days + 1.day + 1.week unless self.start_date.wday == 1
      self.target_date = self.target_date - self.target_date.wday.days + 1.week unless self.target_date.wday == 0
    end
end
