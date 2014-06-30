class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update, :log]
  before_action :correct_user, only: [:show, :edit, :update, :log]

  include UsersHelper
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to RunLogger!"
      redirect_to @user
    else 
      render 'new'
    end 
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def log
    @user = User.find(params[:id])
    @period = params[:period].to_i
    @start = startperiod(@period)
    @end = endperiod(@period)
    @training_plans = create_plan_array(@user.training_plans.where("plan_date >= ? AND plan_date <= ?", (@start - 1.day), @end), @period)
    @training_logs = create_log_array(@user.training_logs.where("log_date >= ? AND log_date <= ?", (@start - 1.day), @end), @period)
    @races = @user.races.all
    @note_array = create_note_array(@user.notes.where("date >= ? AND date <= ?", @start, @end), @period)
  end

  private 

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in" unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
