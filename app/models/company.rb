class Company
  attr_accessor :id, :brand_name, :registration_number, :active

  def initialize(id:, brand_name:, registration_number:, active:)
    @id = id
    @brand_name = brand_name
    @registration_number = registration_number
    @active = active
  end

  def self.all(search_query = nil)
    response = Faraday.get('http://localhost:3000/api/v1/companies')
    companies = []
    if response.status == 200
      data = JSON.parse(response.body)
      companies = build_companies(data, search_query)
    end
    companies
  rescue Faraday::ConnectionFailed
    raise CompanyConnectionError
  end

  def self.find(id)
    response = Faraday.get("http://localhost:3000/api/v1/companies/#{id}")

    return unless response.status == 200

    data = JSON.parse(response.body)

    build_company(data)
  rescue Faraday::ConnectionFailed
    raise CompanyConnectionError
  end

  def matches_search?(search_query)
    return true if search_query.empty?

    regex = /#{Regexp.escape(search_query)}/i
    brand_name.match?(regex) || registration_number.match?(regex)
  end

  class << self
    private

    def build_company(data)
      Company.new(id: data['id'], brand_name: data['brand_name'],
                  registration_number: data['registration_number'], active: data['active'])
    end

    def build_companies(data, search_query)
      companies = []
      data.each do |d|
        company = build_company(d)
        companies << company if search_query.nil? || company.matches_search?(search_query)
      end
      companies
    end
  end
end
