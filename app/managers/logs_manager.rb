class LogsManager < CommonManager

  # Gets the data for the log view.
  def create_logs_array(user, period)
    logs_array = []
    logs = user.logs.where("log_date >= ? AND log_date <= ?", (startperiod(period) - 1.day), endperiod(period))
    7.times do |eachday|
      logs.each do |a_log|
        if (startperiod(period) + eachday.day).mday == a_log.log_date.mday
          logs_array[eachday] = a_log
        end
      end
    end
    logs_array
  end

  # Gets the log to be edited.
  def get_log_for_edit(user, period, day)
    date = startperiod(period.to_i).beginning_of_day + (day.to_i - 1).days
    log = user.logs.where("log_date >= ? AND log_date <= ?", date.beginning_of_day , date.end_of_day).first
  end

  # Create new log.
  def build_log(user, period, day)
    user.logs.build(log_time: "00:00:00", log_date: (startperiod(period.to_i)) + (day.to_i - 1).days)
  end

  # Get any races in the log period.
  def races_in_period(user, period)
    races_array = []
    races = user.races.where("race_date >= ? AND race_date <= ?", (startperiod(period) - 1.day), endperiod(period))
    7.times do |eachday|
      races.each do |a_race|
        if (startperiod(period) + eachday.day).mday == a_race.race_date.mday
          races_array[eachday] = a_race
        end
      end
    end
    races_array
  end 

  # Get a race that exists on the same day as a log.
  def get_race_for_log_day(user, period, day)
    date = startperiod(period.to_i).beginning_of_day + (day.to_i - 1).days
    log = user.races.where("race_date >= ? AND race_date <= ?", date.beginning_of_day, date.end_of_day).first
  end

  def generate_summary(logs)
    summary = {}
    planned_miles = 0
    logged_miles = 0
    logged_calories = 0
    logged_time = 0
    base_time = Time.new("2000-01-01 00:00:00")
    7.times do |x|
      planned_miles += logs[x].plan_miles unless logs[x].nil? || logs[x].plan_miles.nil?
      logged_miles += logs[x].log_miles unless logs[x].nil? || logs[x].log_miles.nil?
      logged_calories += logs[x].log_calories unless logs[x].nil? || logs[x].log_calories.nil?
      logged_time += (logs[x].log_time.to_i - base_time.to_i) unless logs[x].nil? || logs[x].log_time.nil?
    end
    summary = {planned_miles: planned_miles.round(2), logged_miles: logged_miles.round(2), logged_calories: logged_calories, 
            logged_time: logged_time}
    return summary
  end

  def get_current_phase(user, period)
    #find the phase if any that is active over the log period.
    #query the phases manager (need to write the method, should probably just utilise the current logic to buil the array
    #then return an answer based on the period supplied and today's date.
    phase_manager ||= PhasesManager.new
    return phase_manager.get_current_phase(user, period)
    
  end
end

