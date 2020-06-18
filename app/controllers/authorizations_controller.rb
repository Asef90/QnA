class AuthorizationsController < ApplicationController

  def confirmation
  end

  def handle
    @authorization = Authorization.find_by(provider: session[:provider], uid: session[:uid])
    @authorization.update(token: rand(1<<20..1<<30))

    AuthorizationsMailer.confirm_authorization(params[:email], @authorization).deliver_later
  end

  def confirm
    @authorization = Authorization.find(params[:id])

    if @authorization.token == params[:token].to_i
      user = User.find_or_create(params[:email])
      @authorization.update(user_id: user.id, confirmed: true)
    else
      redirect_to root_path, alert: "Something went wrong"
    end
  end
end
