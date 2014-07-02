class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update, :log]
  before_action :correct_user, only: [:show, :edit, :update, :log]

  include UsersHelper
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @logs_8_week = create_weekly_miles_array
    @miles_for_year = yearly_miles
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
