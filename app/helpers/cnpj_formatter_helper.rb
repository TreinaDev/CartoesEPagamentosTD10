module CnpjFormatterHelper
  def cnpj_formatter(cnpj)
    cnpj.gsub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '\1.\2.\3/\4-\5')
  end
end
