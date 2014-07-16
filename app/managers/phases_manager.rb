class PhasesManager < CommonManager
  def create_phase(phase)
    phase = adjust_dates_to_whole_weeks(phase)
    if phase.save
      return true
    else
      return false
    end
  end

  def update_phase(phase, phase_params)
    
    #phase = adjust_dates_to_whole_weeks(phase)
    if phase.update(phase_params)
      return true
    else
      return false
    end
  end
  
  #For each Phase, add the count of its weeks to an array.
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

  #Create an array for each of the phases, showing the split between the different phase types and add to array.
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
        split = [weeks[x] - 18,6,6,6]
      end
      splits << split
    end
    splits
  end
 
  #Used to return the current training cycle  phase to the log.
  def get_current_phase(user, period)
    phase_weeks = []
    training_phase = "No Phase"
    log_start_date = startperiod(period)
    current_phase = user.phases.where("start_date <= ? and target_date >= ?", log_start_date, log_start_date).take
    if !current_phase.nil?
      phase_weeks << get_weeks(current_phase)
      phase_splits = get_phase_split(phase_weeks)
      week_in_phase = ((log_start_date - current_phase.start_date) / 1.week).to_i + 1
      if phase_splits[0][0] >= week_in_phase
        training_phase = "Phase I"
      elsif phase_splits[0][0] + phase_splits[0][1] >= week_in_phase
        training_phase = "Phase II"
      elsif phase_splits[0][0] + phase_splits[0][1] + phase_splits[0][2] >= week_in_phase
        training_phase = "Phase III"
      else
        training_phase = "Phase IV"
      end
    end  
    training_phase  
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
    
    # Ensure that only whole weeks are used in the phases.
    #def adjust_dates_to_whole_weeks(phase)
    #  phase.start_date = phase.start_date - phase.start_date.wday.days + 1.day + 1.week unless phase.start_date.wday == 1
    #  phase.target_date = phase.target_date - phase.target_date.wday.days + 1.week unless phase.target_date.wday == 7
    #  return phase
    #end
end