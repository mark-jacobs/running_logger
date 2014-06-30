class LogsController < ApplicationController
  include LogsHelper
  before_action :signed_in_user
  before_action :correct_user
  def new
    @user = current_user
    @logs = @user.logs.build
  end

  def create
    @user = current_user
    @logs = @user.logs.build(logs_params)
    if @logs.save
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def log
    @user = User.find(params[:id])
    @period = params[:period].to_i
    @start = startperiod(@period)
    @end = endperiod(@period)
    @logs = create_logs_array(@user.logs.where("log_date >= ? AND log_date <= ?", (@start - 1.day), @end), @period)
  end

  private 
    def logs_params
      params.require(:log).permit(:log_date, :plan_workout, :plan_q, :plan_miles, :log_workout, :log_q, :log_miles, 
                           :log_time, :log_calories, :notes)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in" unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
