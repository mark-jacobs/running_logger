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

  def get_phase_split(weeks)
    splits = []
    weeks.length.times do |x|
      case weeks[x]
      when 0
        split = [0,0,0,0]
      when 1..3
        split = [weeks[x],0,0,0]
      when 4..6
        split = [3,0,0, weeks[x] - 3]
      when 7..9
        split = [3,weeks[x] - 6,0,3]
      when 10..12
        split = [3,3,weeks[x] - 9,3]
      when 13
        split = [4,3,3,3]
      when 14..16
        split = [4,3,weeks[x] - 10,3]
      when 17
        split = [4,3,6,4]
      when 18..20
        split = [4,weeks[x] - 14,6,4]
      when 21 
        split = [5,6,6,4]
      when 22
        split = [5,6,6,5]
      when 23
        split = [6,6,6,5]
      else
        split = [6,6,6,6]
      end
      splits << split
    end
    splits
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