# frozen_string_literal: true

class AddPositiveConstraintToPaymentTransactionsBalance < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL.squish
      ALTER TABLE payment_transactions ADD CONSTRAINT balance_positive_check CHECK (balance >= 0);
    SQL
  end

  def down
    execute <<-SQL.squish
      ALTER TABLE payment_transactions DROP CONSTRAINT balance_positive_check;
    SQL
  end
end
