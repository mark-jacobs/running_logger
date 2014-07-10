class CommonManager
  def startperiod(number)
    startperiod = Time.now - (Time.now.wday - 1).day  + number.week
  end

  def endperiod(number)
    startperiod(number) + 1.week
  end
end