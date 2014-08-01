class UsersController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update, :log]
  before_action :correct_user, only: [:show, :edit, :update, :log]
  before_action :not_signed_in, only: [:new, :create]

  include UsersHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @user = User.new
  end

  def show
      @user = User.find(params[:id])
      @logs_8_week = manager.create_weekly_miles_array(@user)
      @miles_for_year = manager.yearly_miles(0, @user)
      @miles_for_last_year = manager.yearly_miles(1, @user)
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = I18n.t(:new_user_success)
      redirect_to @user
    else 
      render 'new'
    end 
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = I18n.t(:update_profile_success)
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
      redirect_to signin_url, notice: I18n.t(:pls_sign_in_msg) unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def manager
      @manager ||= UsersManager.new
    end

    def not_signed_in
      redirect_to(root_url) if signed_in?
    end

    def record_not_found
      flash[:warning] = "Record not found!"
      redirect_to root_url
    end
end
