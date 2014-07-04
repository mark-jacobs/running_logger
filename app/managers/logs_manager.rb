class LogsManager < CommonManager

    # Gets the data for the log view.
  def self.create_logs_array(user, period)
    @logs_array = []
    @logs = user.logs.where("log_date >= ? AND log_date <= ?", (startperiod(period) - 1.day), endperiod(period))
    7.times do |eachday|
      @logs.each do |a_log|
        if (startperiod(period) + eachday.day).mday == a_log.log_date.mday
          @logs_array[eachday] = a_log
        end
      end
    end
    @logs_array
  end
end

