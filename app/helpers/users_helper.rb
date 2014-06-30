module UsersHelper
  def startperiod(number)
    @startperiod = Time.now - (Time.now.wday - 1).day  + number.week
  end

  def endperiod(number)
    startperiod(number) + 1.week
  end

  def create_note_array(notes, period)
    @note_array = {}
    7.times do |eachday|
      notes.each do |a_note|
        if (startperiod(period) + eachday.day).mday == a_note.date.mday
          @note_array[eachday] = a_note
        end
      end
    end
    @note_array
  end

  def create_plan_array(plan, period)
    @plan_array = {}
    7.times do |eachday|
      plan.each do |a_plan|
        if (startperiod(period) + eachday.day).mday == a_plan.plan_date.mday
          @plan_array[eachday] = a_plan
        end
      end
    end
    @plan_array
  end

  def create_log_array(log, period)
    @log_array = {}
    7.times do |eachday|
      log.each do |a_log|
        if (startperiod(period) + eachday.day).mday == a_log.log_date.mday
          @log_array[eachday] = a_log
        end
      end
    end
    @log_array
  end
end
