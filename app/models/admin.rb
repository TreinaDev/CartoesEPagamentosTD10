class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :name, length: { minimum: 5 }
  validates :cpf, cpf: { message: I18n.t('activerecord.errors.models.admin.attributes.cpf.cpf_invalid') }
  validates :cpf, presence: true, uniqueness: true
  validates :cpf, format: {
    with: /[0-9]{11}/,
    message: I18n.t('activerecord.errors.models.admin.attributes.cpf.cpf_minimum_character')
  }
  validates :email, format: {
    with: /[\w+.]+@punti.com\z/,
    message: I18n.t('activerecord.errors.models.admin.attributes.cpf.email_domain')
  }
end
