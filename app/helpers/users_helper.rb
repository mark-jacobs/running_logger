module UsersHelper

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

  def create_weekly_miles_array
    @logs = @user.logs.all
    @log_array = []
    @miles_array = []
    7.downto(0) do |x|
      @miles_total = 0
      @log_array[x] = create_logs_array(@logs, (x*-1))
      @log_array[x].each do |y|
        @miles_total += y.log_miles unless y.nil? || y.log_miles.nil?
      end
      @miles_array[x] = @miles_total
    end
    @miles_array
  end
end
