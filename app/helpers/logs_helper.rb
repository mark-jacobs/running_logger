module LogsHelper
  def startperiod(number)
    @startperiod = Time.now - (Time.now.wday - 1).day  + number.week
  end

  def endperiod(number)
    startperiod(number) + 1.week
  end

  def create_logs_array(logs, period)
    @logs_array = []
    7.times do |eachday|
      logs.each do |a_log|
        if (startperiod(period) + eachday.day).mday == a_log.log_date.mday
          @logs_array[eachday] = a_log
        end
      end
    end
    @logs_array
  end
end
