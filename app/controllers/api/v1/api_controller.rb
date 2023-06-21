class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internet_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request
  before_action :authenticate_api_key

  private

  def internet_server_error
    render status: :internal_server_error, json: { errors: 'Erro interno da Aplicação' }
  end

  def not_found
    render status: :not_found, json: { errors: 'Erro de entidade não encontrada' }
  end

  def bad_request
    render status: :bad_request, json: { errors: 'Erro nos parâmetros enviados' }
  end

  def authenticate_api_key
    api_key = request.headers['Api-Key']
    return render json: { error: 'Chave de API inválida' }, status: :unauthorized unless valid_api_key?(api_key)
  end

  def valid_api_key?(api_key)
    if api_key.present?
      api_key = api_key.sub(/^Token token="/, '').chomp('"')
      ActiveSupport::SecurityUtils.secure_compare(api_key, Rails.application.credentials.api_key)
    else
      false
    end
  end
end
