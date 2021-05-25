# frozen_string_literal: true

class PaymentTransactionsFacade
  extend Memoist

  def initialize(user, start_date, end_date)
    @user = user
    @start_date = start_date&.to_date
    @end_date = end_date&.to_date
    @end_date += 1.day if end_date
  end

  def payment_transactions
    result = @user.payment_transactions
    if @start_date && @end_date
      result = result.where(
        "created_at >= ? AND created_at < ?", @start_date, @end_date
      )
    elsif @start_date
      result = result.where("created_at >= ?", @start_date)
    elsif @end_date
      result = result.where("created_at < ?", @end_date)
    end
    result
  end
  memoize :payment_transactions

  def start_balance
    first_payment_transaction = payment_transactions.first
    if first_payment_transaction
      return first_payment_transaction.balance -
        first_payment_transaction.amount
    end

    @user.payment_transactions.order(created_at: :desc)
         .where("created_at < ?", @start_date).first&.balance || 0
  end
  memoize :start_balance

  def end_balance
    return start_balance if payment_transactions.blank?

    payment_transactions.last.balance
  end
  memoize :end_balance
end
