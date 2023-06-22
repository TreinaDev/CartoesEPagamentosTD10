require 'rails_helper'

describe 'API de consulta de empresas' do
  context 'get/api/v1/companies' do
    it 'deve retorna empresas disponíveis' do
      json_data = Rails.root.join('spec/support/json/companies.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      allow(Faraday).to receive(:get).with('https://temporary-companies-api-treinadev-10.onrender.com/api/v1/companies').and_return(fake_response)

      json_response = JSON.parse(fake_response.body)

      expect(json_response.count).to eq 3
    end

    it 'deve retornar um status 500 se a resposta da API for um Internal Server Error' do
      fake_response = double('faraday_response', status: 500, body: '{}')
      allow(Faraday).to receive(:get).with('https://temporary-companies-api-treinadev-10.onrender.com/api/v1/companies').and_return(fake_response)

      result = Company.all

      expect(result).to be_empty
    end
  end

  context 'get/api/v1/company/:id' do
    it 'deve retornar uma empresa específica a partir de um id' do
      json_data = Rails.root.join('spec/support/json/company.json').read
      fake_response = double('faraday_response', status: 200, body: json_data)
      id = 1
      allow(Faraday).to receive(:get).with("https://temporary-companies-api-treinadev-10.onrender.com/api/v1/companies/#{id}").and_return(fake_response)

      json_response = JSON.parse(fake_response.body)

      expect(json_response['id']).to eq id
      expect(json_response.is_a?(Array)).to eq false
    end

    it 'deve retornar um status 500 se a resposta da API for um Internal Server Error' do
      fake_response = double('faraday_response', status: 500, body: '{}')
      id = 1
      allow(Faraday).to receive(:get).with("https://temporary-companies-api-treinadev-10.onrender.com/api/v1/companies/#{id}").and_return(fake_response)

      result_body = Company.find(1)

      expect(result_body).to be_nil
    end
  end
end
