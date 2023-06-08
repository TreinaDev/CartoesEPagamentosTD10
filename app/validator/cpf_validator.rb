class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if cpf_valid?(value)

    record.errors.add(
      attribute,
      :invalid_cpf,
      message: options[:message] || 'is not valid',
      value:
    )
  end

  private

  DENY_LIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
    01234567890
  ].freeze

  def cpf_valid?(value)
    return false if DENY_LIST.include?(value)

    valid = []
    value.delete('.-')
    cpf_splitted = value.chars
    valid << validation_first_number(cpf_splitted)
    valid << validation_second_number(cpf_splitted)
    valid.count(true) == 2
  end

  def validation_first_number(cpf_splitted)
    sum = cpf_splitted[0..8].each_with_index.sum { |digit, i| digit.to_i * (10 - i) }
    verification = (11 - (sum % 11)) % 10
    verification == cpf_splitted[9].to_i
  end

  def validation_second_number(cpf_splitted)
    validation_second_number = 2.upto(11).to_a.reverse
    sum = validation_second_number.each_with_index.sum { |num, i| cpf_splitted[i].to_i * num }
    validation = sum % 11
    valid = 11 - validation
    verification = valid > 9 ? 0 : valid
    verification == cpf_splitted[10].to_i
  end
end
