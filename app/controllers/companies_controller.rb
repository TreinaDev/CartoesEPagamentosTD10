class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show; end
  #TODO verificar se é possivel passar informações extras de uma view para outra via params. 
end
