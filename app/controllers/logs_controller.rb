class LogsController < ApplicationController
  include LogsHelper

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
    #@training_logs = create_log_array(@user.training_logs.where("log_date >= ? AND log_date <= ?", (@start - 1.day), @end), @period)
    #@races = @user.races.all
    #@note_array = create_note_array(@user.notes.where("date >= ? AND date <= ?", @start, @end), @period)
  end

  private 
    def logs_params
      params.require(:log).permit(:log_date, :plan_workout, :plan_q, :plan_miles, :log_workout, :log_q, :log_miles, 
                           :log_time, :log_calories, :notes)
    end
end
