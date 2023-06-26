require 'rails_helper'

describe 'Administrador muda status de um tipo de cartão vinculado a uma empresa' do
  it 'de ativado para desativado' do
    admin = FactoryBot.create(:admin)
    cashback = FactoryBot.create(:cashback_rule, minimum_amount_points: 10, days_to_use: 10, cashback_percentage: 20)
    gold_card = FactoryBot.create(:card_type, name: 'Gold')
    gold_card.icon.attach(
      io: Rails.root.join('spec/support/images/gold.svg').open,
      filename: 'gold.svg',
      content_type: 'image/svg+xml'
    )
    premium_card = FactoryBot.create(:card_type)
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    FactoryBot.create(:company_card_type, card_type: gold_card, status: :active, cashback_rule: cashback)
    FactoryBot.create(:company_card_type, card_type: premium_card, status: :active)

    allow(Company).to receive(:all).and_return([company])
    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'
    within '#card_type_1' do
      click_on 'Desativar disponibilidade'
    end

    expect(page).to have_content 'Cartão desabilitado para a empresa com sucesso.'
    within '#card_type_1' do
      expect(page).to have_button 'Ativar disponibilidade'
      expect(page).not_to have_button 'Desativar disponibilidade'
    end
    within '#card_type_2' do
      expect(page).not_to have_button 'Ativar disponibilidade'
      expect(page).to have_button 'Desativar disponibilidade'
    end
  end

  it 'de desativado para ativado' do
    admin = FactoryBot.create(:admin)
    cashback = FactoryBot.create(:cashback_rule, minimum_amount_points: 10, days_to_use: 10, cashback_percentage: 20)
    gold_card = FactoryBot.create(:card_type, name: 'Gold')
    gold_card.icon.attach(
      io: Rails.root.join('spec/support/images/gold.svg').open,
      filename: 'gold.svg',
      content_type: 'image/svg+xml'
    )
    premium_card = FactoryBot.create(:card_type)
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    FactoryBot.create(:company_card_type, card_type: gold_card, status: :inactive, cashback_rule: cashback)
    FactoryBot.create(:company_card_type, card_type: premium_card, status: :inactive)

    allow(Company).to receive(:all).and_return([company])
    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'
    within '#card_type_1' do
      click_on 'Ativar disponibilidade'
    end

    expect(page).to have_content 'Cartão habilitado para a empresa com sucesso.'
    within '#card_type_1' do
      expect(page).to have_button 'Desativar disponibilidade'
      expect(page).not_to have_button 'Ativar disponibilidade'
    end
    within '#card_type_2' do
      expect(page).not_to have_button 'Desativar disponibilidade'
      expect(page).to have_button 'Ativar disponibilidade'
    end
  end
end
