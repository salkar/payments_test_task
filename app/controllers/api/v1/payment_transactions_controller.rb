# frozen_string_literal: true

class Api::V1::PaymentTransactionsController < Api::V1::BaseController
  def index
    @facade = PaymentTransactionsFacade.new(
      current_user, params[:start_date], params[:end_date]
    )
  end

  def create
    @service = PaymentTransactions::Create.new(
      user: current_user, params: payment_transaction_params
    )
    @service.perform
    render status: @service.success ? :created : :unprocessable_entity
  end

  private

    def payment_transaction_params
      params.permit(:amount, :name)
    end
end
