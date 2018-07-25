class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  protect_from_forgery with: :exception

  protected

  # Esto se podria haber escrito como:
  # unless User.find_by(id: session[:user_id])
  #   redirect_to ...
  # end
  # Sin embargo es mas efectivo escribir el metodo
  # con una 'Guard clause' ya que todo el metodo esta wrappeado
  # por un unless. Como lo siguiente:
  def authorize
    # vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    return false if User.find_by(id: session[:user_id])
    redirect_to login_path, notice: "Please log in"
  end

  def set_i18n_locale_from_params
    return false unless params[:locale]
    if I18n.available_locales.map(&:to_s).include?(params[:locale])
      I18n.locale = params[:locale]
    else
      flash.now[:notice] = "#{params[:locale]} translation not available"
    end
  end
end
