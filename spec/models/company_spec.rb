require 'rails_helper'

describe Company do
  context '.all' do
    it 'deve retornar todas as empresas' do
      json_data = Rails.root.join('spec/support/json/companies.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('link_da_outra_aplicacao').and_return(fake_response)

      result = Company.all

      expect(result.size).to eq 3
      expect(result[0].id).to eq 1
      expect(result[0].brand_name).to eq 'Samsung'
      expect(result[0].registration_number).to eq '71.223.406/0001-81'
      expect(result[1].id).to eq 2
      expect(result[2].id).to eq 3
    end

    it 'deve retornar um status 500 se a resposta da API for um Internal Server Error' do
      fake_response = double('faraday_response', status: 500, body: '{}')
      allow(Faraday).to receive(:get).with('link_da_outra_aplicacao').and_return(fake_response)

      result_body = Company.all
      result_status = fake_response.status

      expect(result_status).to eq 500
      expect(result_body).to be_empty
    end
  end

  context '.find' do
    context 'deve receber um id' do
      it 'e retornar uma empresa' do
        json_data = Rails.root.join('spec/support/json/company.json').read
        fake_response = double('faraday_response', status: 200, body: json_data)
        allow(Faraday).to receive(:get).with('link_da_outra_aplicacao/1').and_return(fake_response)

        result = Company.find(1)

        expect(result.brand_name).to eq 'Samsung'
        expect(result.registration_number).to eq '71.223.406/0001-81'
      end

      it 'deve retornar um status 500 se a resposta da API for um Internal Server Error' do
        fake_response = double('faraday_response', status: 500, body: '{}')
        allow(Faraday).to receive(:get).with('link_da_outra_aplicacao/1').and_return(fake_response)

        result_body = Company.find(1)
        result_status = fake_response.status

        expect(result_status).to eq 500
        expect(result_body).to be_nil
      end
    end
  end
end
