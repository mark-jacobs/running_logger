class PhasesManager
  def create_phase(phase)
    if phase.save
      return true
    else
      return false
    end
  end

  def get_phase_weeks(phases)
    phase_weeks = []
    count = 0
    phases.each do |x|
      weeks = get_weeks(x)
      phase_weeks[count] = weeks
      count += 1
    end
    return phase_weeks
  end

  private

    def get_weeks(a_phase)
      if a_phase.start_date.wday != 1
        start = a_phase.start_date - a_phase.start_date.wday.days + 1.day + 1.week
      else
        start = a_phase.start_date
      end
      if a_phase.target_date.wday != 7
        target = a_phase.target_date - a_phase.target_date.wday.days - 1.day + 1.week
      else
        target = a_phase.target_date
      end
      weeks = (target.beginning_of_day.to_i - start.beginning_of_day.to_i) / 1.weeks.to_i
      weeks = 0 unless weeks > 0
      return weeks
    end
end