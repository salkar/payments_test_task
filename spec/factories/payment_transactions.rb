# frozen_string_literal: true

FactoryBot.define do
  factory :payment_transaction do
    amount { 100 }
    balance { 0 }
    name { Faker::Lorem.word }
    user
  end
end
