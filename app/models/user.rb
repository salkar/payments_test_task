# frozen_string_literal: true

class User < ApplicationRecord
  has_many :payment_transactions, dependent: :restrict_with_error
end
