class PhasesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  def new
    @phase = @user.phases.build
  end

  private 
    def signed_in_user
      redirect_to root_url unless signed_in?
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to root_url unless current_user?(@user)
    end 
end
