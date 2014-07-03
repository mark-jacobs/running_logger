class LogsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  before_action :set_user, only: [:new, :create, :update]
  before_action :set_period, only: [:new, :log, :edit]

  def new
    @logs = @user.logs.build(log_date: (LogsManager.startperiod(params[:period].to_i)) + (params[:day].to_i - 1).days)
  end

  def create
    @logs = @user.logs.build(logs_params)
    if @logs.save
      flash[:sucess] = "Log created"
      redirect_to "/users/#{params[:user_id]}/log/#{params[:period]}"
    else
      render 'new'
    end
  end
  
  def log
    @user = User.find(params[:user_id])
    @start = LogsManager.startperiod(@period)
    @logs = LogsManager.create_logs_array(@user, @period)
  end

  def edit
    @user = User.find(params[:user_id])
    @date = LogsManager.startperiod(params[:period].to_i).beginning_of_day + (params[:day].to_i - 1).days
    @log = @user.logs.where("log_date >= ? AND log_date <= ?", @date.beginning_of_day , @date.end_of_day).first
    
  end

  def update
    @log = @user.logs.find(params[:id])
    if @log.update(logs_params)
      flash[:success] = "Log updated"
      redirect_to "/users/#{params[:user_id]}/log/#{params[:period]}"
    else
      render 'edit'
    end

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
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def set_user
      @user = current_user
    end

    def set_period
      @period = params[:period].to_i
    end
end
