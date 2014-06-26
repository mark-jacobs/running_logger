module UsersHelper
  def startperiod(number)
    @startperiod = Time.now - Time.now.wday.day + 1.day + (number -1).week
  end
end
