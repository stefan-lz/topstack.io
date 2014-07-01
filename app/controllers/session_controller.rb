class SessionController < ApplicationController

  #turn off csrf for omniauth
  skip_before_action :verify_authenticity_token

  def create
    @user = User.find_by_omniauth(auth_hash) || User.create_with_omniauth!(auth_hash)
    self.current_user = @user
    redirect_to root_url, :notice => 'Signed in'
  end

  def destroy
    self.current_user = nil
    redirect_to root_url, :notice => 'Signed out'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
