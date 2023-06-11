class ApplicationController < ActionController::Base
  rescue_from Faraday::ConnectionFailed, with: :internal_server_error

  def not_found
    render file: Rails.public_path.join('404.html'), layout: false, status: :not_found
  end

  def internal_server_error
    render file: Rails.public_path.join('500.html'), layout: false, status: :internal_server_error
  end
end
