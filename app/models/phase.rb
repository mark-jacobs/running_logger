class Phase < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :start_date, presence: true 
  validates :target_date, presence: true
  validate :range_cannot_be_covered_by_other_phase

  def range_cannot_be_covered_by_other_phase
    phases = Phase.all
    phases.each do |each_phase|
      if target_date.to_i <= each_phase.target_date.to_i && target_date.to_i >= each_phase.start_date.to_i
        errors.add(:target_date, "is covered by another training period")
      end 
      if start_date.to_i <= each_phase.target_date.to_i && start_date.to_i >= each_phase.start_date.to_i
        errors.add(:start_date, "is covered by another training period")
      end
    end
  end
end
