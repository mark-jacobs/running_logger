class LogsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  before_action :set_user, only: [:new, :create, :update]
  before_action :set_period, only: [:new, :log, :edit]

  def new
    @logs = LogsManager.build_log(@user, params[:period], params[:day])
  end

  def create
    @logs = @user.logs.build(logs_params)
    if @logs.save
      redirect_to "/users/#{params[:user_id]}/log/#{params[:period]}"
    else
      render 'new'
    end
  end
  
  def log
    @start = LogsManager.startperiod(@period)
    @logs = LogsManager.create_logs_array(@user, @period)
    @races = LogsManager.races_in_period(@user, @period)
  end

  def edit
    @log = LogsManager.get_log_for_edit(@user, params[:period], params[:day])
    @period = params[:period]
  end

  def destroy
    @log = @user.logs.find(params[:id])
    @log.destroy
    redirect_to  "/users/#{current_user.id}/log/#{params[:period]}"
  end

  def update
    @log = @user.logs.find(params[:id])
    if @log.update(logs_params)
      redirect_to "/users/#{params[:user_id]}/log/#{params[:period]}"
    else
      render 'edit'
    end
  end

  private 
    def logs_params
      params.require(:log).permit(:log_date, :plan_workout, :plan_q, :plan_miles, :log_workout, :log_q, :log_miles, 
                           :log_time, :log_calories, :notes, :period)
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
