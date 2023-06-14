class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Faraday::ConnectionFailed, with: :internal_server_error

  def not_found
    render file: Rails.public_path.join('404.html'), layout: false, status: :not_found
  end

  def internal_server_error
    render file: Rails.public_path.join('500.html'), layout: false, status: :internal_server_error
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[cpf name])
  end
end
