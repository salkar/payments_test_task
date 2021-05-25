# frozen_string_literal: true

json.set! :data do
  json.set! :payment_transactions do
    json.array!(@facade.payment_transactions) do |payment_transaction|
      json.name payment_transaction.name
      json.amount payment_transaction.amount
      json.date payment_transaction.created_at.to_date
    end
  end
  json.start_balance @facade.start_balance
  json.end_balance @facade.end_balance
end
