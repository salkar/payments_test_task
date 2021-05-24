# frozen_string_literal: true

class PaymentTransactions::Create < ApplicationService
  attr_accessor :params, :user
  attr_reader :amount, :payment_transaction

  validates :user, presence: true
  validates :amount, numericality: { other_than: 0 }
  validate :check_amount

  def initialize(_params = {})
    super
    @amount = params[:amount].to_i
  end

  def perform
    return if invalid?

    PaymentTransaction.transaction do
      User.where(id: user).update_all("balance = balance + #{amount}")
      @payment_transaction = PaymentTransaction.new(
        params.merge(balance: user.reload.balance, user: user)
      )
      payment_transaction.save!
    end
    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid
    false
  end

  def errors
    payment_transaction&.errors.presence || super
  end

  private

    def check_amount
      return if amount >= 0
      return if amount.negative? && user.balance + amount >= 0

      errors.add(:amount, :not_enough_balance)
    end
end
