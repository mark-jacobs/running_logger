class CommonManager

  # period calculators used for getting results for views.
  def self.startperiod(number)
    @startperiod = Time.now - (Time.now.wday - 1).day  + number.week
  end

  def self.endperiod(number)
    startperiod(number) + 1.week
  end
end