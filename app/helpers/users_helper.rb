module UsersHelper
  def startperiod(number)
    @startperiod = Time.now - Time.now.wday.day + 1.day + (number -1).week
  end

  def endperiod(number)
    startperiod(number) + 4.week
  end

  def create_note_array(notes, period)
    @note_array = {}
    28.times do |eachday|
      notes.each do |a_note|
        if (startperiod(period) + eachday.day).mday == a_note.date.mday
          @note_array[eachday - 1] = a_note
        end
      end
    end
    @note_array
  end
end
