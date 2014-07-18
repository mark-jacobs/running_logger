class LogImportController < ApplicationController
  require 'csv'

  def new

  end
  ###########################Don't forget to create transactions for import.
  def create
    ##########################################################
    ## This works but uses the path to open the csv....
    # csv_path = params[:file].path unless params[:file].nil?
    # if csv_path.nil?
    #   render 'new'
    # else
    #   user = current_user
    #   log_params = {}
    #   CSV.foreach(csv_path, headers: true) do |row|
    #     log_params[:log_date] = row[0]
    #     log_params[:plan_miles] = row[1]
    #     log_params[:plan_workout] = row[2]
    #     log_params[:log_miles] = row[3]
    #     log_params[:log_workout] = row[4]
    #     log_params[:log_calories] = row[5]
    #     if row[6].nil?
    #       log_params[:log_time] = "00:00:00"
    #     else
    #       log_params[:log_time] = row[6]
    #     end
    #     log_params[:notes] = row[7]
    #     new_log = user.logs.build(log_params)
    #     new_log.save
    #   end
    #   redirect_to root_url, notice: "Yayy!"  
    # end  
    ##########################################################
    if params[:file].nil?
      render 'new'
    else
      csv_string = params[:file].read
      csv = CSV.parse(csv_string, encoding: "UTF-8", headers: true)
      user = current_user
      count = 0
      csv.each do |row|
        log_params = {}
        log_params[:log_date] = row[0]
        log_params[:plan_miles] = row[1]
        log_params[:plan_workout] = row[2]
        log_params[:log_miles] = row[3]
        log_params[:log_workout] = row[4]
        log_params[:log_calories] = row[5]
        if row[6].nil?
          log_params[:log_time] = "00:00:00"
        else
          log_params[:log_time] = row[6]
        end
        log_params[:notes] = row[7]
        new_log = user.logs.build(log_params)
        new_log.save
        puts "Added row #{count}"
        count += 1
      end
      redirect_to "/users/#{current_user.id}/log/0", notice: "Logs imported"
    end
  end
end
