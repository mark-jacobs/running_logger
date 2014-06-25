class TrainingLogsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user

  def new
    @user = current_user
    @training_log = @user.training_logs.build
  end

  def create 
    @user = current_user
    @training_log = @user.training_logs.build(training_log_params)
    if @training_log.save
      redirect_to user_training_plans_path(current_user)
    else
      render 'new'
    end
  end

  def index 
    @user = current_user
    @training_logs = @user.training_logs
  end

  private

    def training_log_params
      params.require(:training_log).permit(:log_date, :log_miles, :log_workout, :log_q, 
                      :log_calories, :log_notes)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in" unless signed_in?
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
