# frozen_string_literal: true

if @service.success
  json.set! :data do
    json.set! :payment_transaction do
      json.name @service.payment_transaction.name
      json.amount @service.payment_transaction.amount
      json.date @service.payment_transaction.created_at.to_date
    end
  end
else
  json.set! :errors, @service.errors.details
end
