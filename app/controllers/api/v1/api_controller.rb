class Api::V1::ApiController < ActionController::API
  include AbstractController::Translation
  
  rescue_from ActiveRecord::ActiveRecordError, with: :internet_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

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
end
