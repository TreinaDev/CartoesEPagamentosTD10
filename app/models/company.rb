class Company
  attr_accessor :id, :brand_name, :registration_number, :active

  def initialize(id:, brand_name:, registration_number:, active:)
    @id = id
    @brand_name = brand_name
    @registration_number = registration_number
    @active = active
  end

  def self.all
    companies = []
    response = Faraday.get('http://localhost:3000/api/v1/companies')

    if response.status == 200
      data = JSON.parse(response.body)
      data.each { |d| companies << build_company(d) }
    end

    companies
  end

  def self.find(id)
    response = Faraday.get("http://localhost:3000/api/v1/companies/#{id}")

    return unless response.status == 200

    data = JSON.parse(response.body)

    build_company(data)
  end

  class << self
    private

    def build_company(data)
      Company.new(id: data['id'], brand_name: data['brand_name'],
                  registration_number: data['registration_number'], active: data['active'])
    end
  end
end
