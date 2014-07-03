class RacesManager
  # Retrieve upcoming races data for view in ascending order.
  def self.build_upcoming_race_index(a_user)
    @races = a_user.races.where("finish_time IS NULL OR finish_time = ?", "2000-01-01 00:00:00").order(race_date: :asc)
  end

  # Retrieve completed races data for view in descending order.
  def self.build_completed_race_index(a_user)
    @races = a_user.races.where("finish_time IS NOT NULL AND finish_time <> ?", Time.new("2000-01-01 00:00:00")).order(race_date: :desc)
  end
end