class TrainingPlansController < ApplicationController
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
end
