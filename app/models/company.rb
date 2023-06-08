class Company
  attr_accessor :id, :brand_name, :registration_number

  def initialize(id:, brand_name:, registration_number:)
    @id = id
    @brand_name = brand_name
    @registration_number = registration_number
  end

  def self.all
    companies = []
    
    response = Faraday.get('link_da_outra_aplicação')

    if response.status == 200
      data = JSON.parse(response.body)

      data.each do |d|
        companies << Company.new(id: d['id'], brand_name: d['brand_name'],
                                 registration_number: d['registration_number'])
      end
    end
    #TODO Pedir API para o time de empresas
    companies
  end
end
