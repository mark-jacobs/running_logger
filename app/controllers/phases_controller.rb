class PhasesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  
  def new
    @phase = @user.phases.build
  end

  def create
    # Create a manager method for creating the phase, check to see if period is covered by another phase
    @phase = @user.phases.build(phases_params)
    manager.create_phase(@phase)
    redirect_to root_url
  end

  def index
    @phases = @user.phases.all
  end

  private 

    def signed_in_user
      redirect_to root_url unless signed_in?
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to root_url unless current_user?(@user)
    end 

    def phases_params
      params.require(:phase).permit(:start_date, :target_date, :include_phase_I)
    end

    def manager
      @manager ||= PhasesManager.new
    end
end
