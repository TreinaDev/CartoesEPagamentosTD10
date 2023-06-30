class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CompanyConnectionError, with: :company_connection_error

  def after_sign_out_path_for(_resource)
    new_admin_session_path
  end

  def not_found
    render file: Rails.public_path.join('404.html'), layout: false, status: :not_found
  end

  def company_connection_error
    redirect_to root_path, notice: I18n.t('.alerts.company_connection_error')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[cpf name])
  end
end
