class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user=(user)
    @current_user = user

    if @current_user.nil?
      session[:user_id] = nil
    else
      session[:user_id] = @current_user.id
    end
  end

  def current_user(create_guest: false)
    @current_user ||=
    begin
      User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      User.create_guest!.tap { |u|
        session[:user_id] = u.id
      } if create_guest
    end
  end

  def auth_path
    if ['development', 'test'].include? Rails.env
      '/auth/developer'
    else
      '/auth/stackexchange'
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  helper_method :auth_path, :current_user

end
