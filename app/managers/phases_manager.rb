class PhasesManager
  def create_phase(phase)
    if phase.save!
      return true
    else
      return false
    end
  end
end