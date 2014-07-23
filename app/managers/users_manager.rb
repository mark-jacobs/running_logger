class UsersManager < CommonManager
  


  def create_weekly_miles_array(user)
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


  def yearly_miles(a_year, a_user)
    logs = logs_for_year(a_year, a_user)
    years_miles = 0
    logs.each do |x|
      years_miles += x.log_miles unless x.log_miles.nil?
    end
    years_miles
  end
  
  private 

    def logs_for_year(a_year, a_user)
      b_o_y = "#{Time.now.year - a_year}-01-01 00:00:00"
      e_o_y = "#{Time.now.year - a_year}-12-31 23:59:59"
      logs = a_user.logs.where("log_date >= ? AND log_date <= ?", b_o_y, e_o_y)
      return logs
    end

    def create_logs_array(logs, period)
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
end