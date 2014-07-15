class PhasesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  
  def new
    @phase = @user.phases.build
  end

  def create
    @phase = @user.phases.build(phases_params)
    if manager.create_phase(@phase)
      redirect_to "/users/#{params[:user_id]}/phases"
    else
      render 'new'
    end
  end
  
  def edit
  end

  def update
  end

  def index
    @phases = @user.phases.all
    @phase_weeks = manager.get_phase_weeks(@phases)
    @phase_splits = manager.get_phase_split(@phase_weeks)
  end

  def destroy
    @phase = @user.phases.find(params[:id])
    if @phase.destroy
      redirect_to user_phases_path
    else
      redirect_to root_url
    end
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
