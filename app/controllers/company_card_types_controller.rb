class CompanyCardTypesController < ApplicationController
  def create
    company_card_type = CompanyCardType.find_by(cnpj: params[:company_registration_number],
                                                card_type_id: params[:card_type_id])

    if company_card_type.blank?
      new_relation
    else
      update_relation(company_card_type)
    end
  end

  def update
    cnpj = params[:company_registration_number]
    card_type_id = params[:card_type_id]
    company_card_type = CompanyCardType.find_by(cnpj: cnpj, card_type_id: card_type_id)

    if company_card_type.unavailable!
      flash[:notice] = 'Cartão indisponibilizado com sucesso.'
    else
      flash[:notice] = company_card_type.errors.full_messages[0]
    end
    
    redirect_to company_path(params[:company_id])
  end

  private

  def new_relation
    cnpj = params[:company_registration_number]
    card_type_id = params[:card_type_id]
    company_card_type = CompanyCardType.new(cnpj: cnpj, card_type_id: card_type_id, status: 1)

    if company_card_type.save
      redirect_to company_path(params[:company_id]), notice: 'Cartão disponibilizado com sucesso.'
    else
      redirect_to company_path(params[:company_id]), notice: company_card_type.errors.full_messages[0]
    end
  end

  def update_relation(company_card_type)
    if company_card_type.available!
      redirect_to company_path(params[:company_id]), notice: 'Cartão disponibilizado com sucesso.'
    else
      redirect_to company_path(params[:company_id]), notice: company_card_type.errors.full_messages[0]
    end
  end
end
