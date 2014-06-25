class TrainingPlansController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  
  def new
    @user = current_user
    @training_plan = @user.training_plans.build
  end

  def create
    @user = current_user
    if @training_plan = @user.training_plans.create(training_plan_params)
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @user = current_user
    @training_plans = @user.training_plans
  end

  private

    def training_plan_params
      params.require(:training_plan).permit(:plan_date, :plan_miles, :plan_workout, :plan_q)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in" unless signed_in?
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
