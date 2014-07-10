
class RacesController < ApplicationController 
  before_action :signed_in_user
  before_action :correct_user
  before_action :set_user
  before_action :get_race, only: [:destroy, :show, :edit, :update]


  def new
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
    @upcoming_races = manager.build_upcoming_race_index(@user)
    @completed_races = manager.build_completed_race_index(@user)
  end

  def destroy
    if @race.destroy
      redirect_to user_races_path
    else
      redirect_to root_path
    end
  end

  def edit
    if @race.finish_time.nil?
      @race.finish_time = "00:00:00"
    end
  end

  def update
    if @race.update(race_params)
      flash[:success] = "Race updated"
      redirect_to user_races_path(current_user)
    else
      render 'edit'
    end
  end

  def pb
    @results = manager.get_pb_races(current_user)
  end

  def distance
    @dist_races = manager.get_distance_races(current_user, params[:dist])
    @dist = params[:dist]
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

    def get_race  
      @race = @user.races.find(params[:id])
    end

    def manager
      @manager ||= RacesManager.new
    end
end
