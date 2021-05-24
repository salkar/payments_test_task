# frozen_string_literal: true

class PaymentTransaction < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true
  validates :balance, presence: true
  validates :name, presence: true
end
