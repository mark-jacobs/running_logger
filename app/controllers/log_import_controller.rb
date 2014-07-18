class LogImportController < ApplicationController
  require 'csv'
  def new

  end
  ###########################Don't forget to create transactions for import.
  def create
    csv = params[:file]
    if false
      #render 'new'
    else

      #csv = CSV.parse(csv_text, headers: true, col_sep: ',')
      user = current_user
      log_params = {}

      CSV.foreach('/users/markjacobs/documents/csvimportsheet.csv', headers: true) do |row|
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
      end
    end  
    redirect_to root_url, notice: "Yayy!"
  
  end
end
