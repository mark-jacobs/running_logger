class UsersManager < CommonManager
  def self.create_logs_array(logs, period)
    logs_array = []
    7.times do |eachday|
      logs.each do |a_log|
        if (startperiod(period) + eachday.day).mday == a_log.log_date.mday
          logs_array[eachday] = a_log
        end
      end
    end
    logs_array
  end

  def self.create_weekly_miles_array(user)
    log_array = []
    miles_array = []
    7.downto(0) do |x|
      logs = user.logs.where("log_date >= ? AND log_date <= ?", (startperiod(x*-1) - 1.day) , endperiod(x*-1))
      miles_total = 0
      log_array[x] = create_logs_array(logs, (x*-1))
      log_array[x].each do |y|
        miles_total += y.log_miles unless y.nil? || y.log_miles.nil?
      end
      miles_array[x] = miles_total
    end
    miles_array
  end

  def self.logs_for_year(year, user)
    logs = user.logs.where("log_date >= ? AND log_date <= ?", "#{Time.now.year - year}-01-01 00:00:00" , 
      "#{Time.now.year - year}-12-31 23:59:59")
    return logs
  end

  def self.yearly_miles(year, user)
    logs = logs_for_year(year, user)
    years_miles = 0
    logs.each do |x|
      years_miles += x.log_miles unless x.log_miles.nil?
    end
    years_miles
  end
end