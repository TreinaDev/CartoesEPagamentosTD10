class ErrorsAssociation < ApplicationRecord
  belongs_to :payment
  belongs_to :error_message
end
