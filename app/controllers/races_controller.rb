class RacesController < ApplicationController
  
  def new
    @user = current_user
    @race = @user.races.build
  end

  def create
    @user = current_user
    @race = @user.races.build(race_params)
    if @race.save
      redirect_to user_races_path
    else
      render 'new'
    end
  end

  def index
    @user = current_user
    @races = @user.races.all.order(race_date: :asc)
  end

  def show
    @user = current_user
    @race = @user.races.find(params[:id])
  end

  def destroy
    @user = current_user
    @race = @user.races.find(params[:id])
    if @race.destroy
      redirect_to user_races_path
    else
      redirect_to root_path
    end
  end

  def edit
    @user = current_user
    @race = @user.races.find(params[:id])
    if @race.finish_time.nil?
      @race.finish_time = "00:00:00.000"
    end
  end

  def update
    @user = current_user
    @race = @user.races.find(params[:id])
    if @race.update(race_params)
      flash[:success] = "Profile updated"
      redirect_to user_races_path(current_user)
    else
      render 'edit'
    end
  end

  private
  
    def race_params
     params.require(:race).permit(:race_name, :race_date, :distance, :finish_time, :position)
    end
end
