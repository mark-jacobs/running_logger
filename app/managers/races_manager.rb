class RacesManager
  # Retrieve upcoming races data for view in ascending order.
  def build_upcoming_race_index(a_user)
    races = a_user.races.where("finish_time IS NULL OR finish_time = ?", Time.new("2000-01-01 00:00:00")).order(race_date: :asc)
  end

  # Retrieve completed races data for view in descending order.
  def build_completed_race_index(a_user)
    races = a_user.races.where("finish_time IS NOT NULL AND finish_time <> ?", Time.new("2000-01-01 00:00:00")).order(race_date: :desc)
  end

  # Returns an array of the users pb performances for race distances where finish times exist.
  def get_pb_races(a_user)
    pb_races = []
    race_distances = a_user.races.select(:distance).where.not(finish_time: Time.new("2000-01-01 00:00:00")).distinct

    race_distances.each do |eachdistance|
      race = a_user.races.order('distance, finish_time ASC').where.not(finish_time: Time.new("2000-01-01 00:00:00")).find_by(distance: eachdistance.distance)
      pb_races << race
    end
    pb_races
  end

  # Returns all results for user, distance)
  def get_distance_races(a_user, dist)
    races = a_user.races.where(distance: dist).where.not(finish_time: Time.new("2001-01 00:00:00"))
  end
end 