# frozen_string_literal: true

class CreatePaymentTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_transactions do |t|
      t.bigint :amount, null: false
      t.bigint :balance, null: false
      t.text :name, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
