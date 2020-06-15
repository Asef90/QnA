class AuthorizationsController < ApplicationController
  before_action :set_authorization, only: %i[handle confirm]

  def confirmation
  end

  def handle
    @authorization.update(token: rand(1<<20..1<<30))

    session[:user_email] = params[:email]
    AuthorizationsMailer.confirm_authorization(params[:email], @authorization.token).deliver_now
  end

  def confirm
    if @authorization.token == params[:token].to_i
      user = User.find_or_create(session[:user_email])
      @authorization.update(user_id: user.id, confirmed: true)
    else
      redirect_to root_path, alert: "Something went wrong"
    end
  end

  private

  def set_authorization
    @authorization = Authorization.find_by(provider: session[:provider], uid: session[:uid])
  end
end
