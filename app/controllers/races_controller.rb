class RacesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user
  before_action :set_user

  def new
    @user = current_user
    @race = @user.races.build
  end

  def create
    @race = @user.races.build(race_params)
    if @race.save
      redirect_to user_races_path
    else
      render 'new'
    end
  end

  def index
    @races = @user.races.all.order(race_date: :asc)
  end

  def show
    @race = @user.races.find(params[:id])
  end

  def destroy
    @race = @user.races.find(params[:id])
    if @race.destroy
      redirect_to user_races_path
    else
      redirect_to root_path
    end
  end

  def edit
    @race = @user.races.find(params[:id])
    if @race.finish_time.nil?
      @race.finish_time = "00:00:00"
    end
  end

  def update
    @race = @user.races.find(params[:id])

    race_params[:finish_time] = "Flower"
    if @race.update(race_params)
      flash[:success] = "Race updated"
      redirect_to user_races_path(current_user)
    else
      render 'edit'
    end
  end

  private
  
    def race_params
     params.require(:race).permit(:race_name, :race_date, :distance, :finish_time, :position)
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
end
