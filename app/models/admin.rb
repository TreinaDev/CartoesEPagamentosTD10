class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :name, length: { minimum: 10 }
  validates :cpf, cpf: { message: 'CPF inválido' }
  validates :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, format: { with: /[0-9]{11}/, message: 'precisa ter 11 dígitos' }
  validates :email, format: { with: /[\w+.]+@punti.com\z/, message: 'precisa pertencer ao domínio @punti.com' }
end
