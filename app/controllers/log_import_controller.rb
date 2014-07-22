class LogImportController < ApplicationController
  require 'csv'

  def new

  end

  def create
    if params[:file].nil?
      render 'new'
    else
      msg = log_import_manager.import_csv(params[:file], current_user)
      redirect_to "/users/#{current_user.id}/log/0", notice: "#{msg}"
    end
  end

  private

    def log_import_manager
      log_import_manager ||= LogImportManager.new
    end
end
