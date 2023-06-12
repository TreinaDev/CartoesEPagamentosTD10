class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :internet_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def internet_server_error
    render status: :internal_server_error, json: { errors: 'Erro interno da Aplicação' }
  end

  def not_found
    render status: :not_found, json: { errors: 'Erro de entidade não encontrada' }
  end
end
