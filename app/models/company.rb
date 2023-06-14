class Company
  attr_accessor :id, :brand_name, :registration_number

  def initialize(id:, brand_name:, registration_number:)
    @id = id
    @brand_name = brand_name
    @registration_number = registration_number
  end

  def self.all
    companies = []
    response = Faraday.get('https://temporary-companies-api-treinadev-10.onrender.com/api/v1/companies')

    if response.status == 200
      data = JSON.parse(response.body)
      data.each { |d| companies << build_company(d) }
    end

    companies
  end

  def self.find(id)
    response = Faraday.get("https://temporary-companies-api-treinadev-10.onrender.com/api/v1/companies/#{id}")

    return unless response.status == 200

    data = JSON.parse(response.body)

    build_company(data)
  end

  class << self
    private

    def build_company(data)
      Company.new(id: data['id'], brand_name: data['brand_name'],
                  registration_number: data['registration_number'])
    end
  end
end
