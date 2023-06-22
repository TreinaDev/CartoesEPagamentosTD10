class ErrorMessage < ApplicationRecord
  validates :code, :description, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 3 }

  has_many :errors_associations, dependent: :restrict_with_exception
end
