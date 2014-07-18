class LogImportController < ApplicationController
  require 'csv'

  def new

  end

  def create
    if params[:file].nil?
      render 'new'
    else
      msg = "Imported!"
      count = 0
      begin
        ActiveRecord::Base.transaction do
          csv_string = params[:file].read
          csv = CSV.parse(csv_string, encoding: "UTF-8", headers: true)
          user = current_user
          csv.each do |row|
            count += 1
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
            new_log.save!
          end
        end
      rescue Exception => e
        msg = e.message + " at row #{count}"
      end
      redirect_to "/users/#{current_user.id}/log/0", notice: "Error: #{msg}"
    end
  end
end
