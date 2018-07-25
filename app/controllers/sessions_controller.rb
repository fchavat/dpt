class SessionsController < ApplicationController
  skip_before_action :authorize
  
  def new
  end

  def create
    if User.count != 0
      user = User.find_by(name: params[:name])
      # if user.try(:authenticate, params[:password])
      # Mejor forma es usando Safe Navigation (&.)
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to admin_url
      else
        redirect_to login_path, alert: "Invalid user/password combination"
      end
    else
      # Si no existen usuarios, el login crea el primero.
      new_user = User.create(name: params[:name], password: params[:password])
      session[:user_id] = new_user.id
      redirect_to admin_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notie: 'Logged out!'
  end
end
