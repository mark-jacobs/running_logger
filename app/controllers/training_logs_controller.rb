class TrainingLogsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user

  def new
    @user = current_user
    @training_log = @user.training_logs.build
    @training_log.log_time = "00:00:00.000"
  end

  def create 
    @user = current_user
    @training_log = @user.training_logs.build(training_log_params)
    if @training_log.save
      redirect_to user_training_logs_path(current_user)
    else
      render 'new'
    end
  end

  def index 
    @user = current_user
    @training_logs = @user.training_logs
  end

  def edit
    @user = current_user
    @training_log = @user.training_logs.find(params[:id])
    if @training_log.log_time.nil?
      @training_log.log_time = "00:00:00.000"
    end
  end

  def update
    @user = current_user
    @training_log = @user.training_logs.find(params[:id])
    if @training_log.update(training_log_params)
      redirect_to user_training_logs_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    @training_log = @user.training_logs.find(params[:id])
    @training_log.destroy
    redirect_to user_training_logs_path
  end


  private

    def training_log_params
      params.require(:training_log).permit(:log_date, :log_miles, :log_workout, :log_q, 
                      :log_calories, :log_notes, :log_time)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in" unless signed_in?
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
