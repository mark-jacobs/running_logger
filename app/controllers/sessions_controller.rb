class SessionsController < ApplicationController
  before_action :not_signed_in, only: [:new, :create]
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = I18n.t(:invalid_combination)
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  private

    def not_signed_in
      if signed_in?
        flash[:warning] = I18n.t(:already_signed_in)
        redirect_to root_url
      end
    end
end
