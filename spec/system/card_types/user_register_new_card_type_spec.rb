require 'rails_helper'

describe 'Usuário tenta registar um novo tipo de cartão' do
    it 'com sucesso' do
        visit root_path
        click_on 'Novo tipo de cartão'
        fill_in('Nome', with: 'Premium')
        fill_in('Ícone', with: 'https://i.imgur.com/YmQ9jRN.png')
        fill_in('Pontos iniciais', with:'67')
        click_on 'Salvar'

        expect(page).to have_content('Novo tipo de cartão criado com sucesso')
        expect(page).to have_content('Cartão Premium')
        expect(page).to have_content('Pontos iniciais: 67')
        expect(page).to have_css("img[src*='YmQ9jRN.png']")
    end

    it 'com falha, pois o tipo de cartão já existe' do
        FactoryBot.create(:card_type)

        visit root_path
        click_on 'Novo tipo de cartão'
        fill_in('Nome', with: 'Premium')
        fill_in('Ícone', with: 'https://i.imgur.com/YmQ9jRN.png')
        fill_in('Pontos iniciais', with:'50')
        click_on 'Salvar'

        expect(page).to have_content('Não foi possível criar um novo tipo de cartão')
        expect(page).to have_content('Verifique os erros abaixo:')
        expect(page).to have_content('Nome já está em uso')
    end
end