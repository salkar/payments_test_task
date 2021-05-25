# frozen_string_literal: true

RSpec.describe Api::V1::PaymentTransactionsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { user.token }

  describe "GET /api/v1/payment_transactions" do
    let(:params) { { start_date: "2021-05-15", end_date: "2021-05-17" } }
    let(:payment_transactions_facade_double) do
      double("PaymentTransactionsFacade")
    end
    let!(:payment_transaction) { create(:payment_transaction, user: user) }
    let(:payment_transactions_result) { [payment_transaction] }
    let(:start_balance_result) { 1000 }
    let(:end_balance_result) { 3000 }

    subject do
      get("/api/v1/payment_transactions",
          params: params,
          headers: { "Authentication" => "Bearer #{token}" })
    end

    before do
      allow(PaymentTransactionsFacade)
        .to receive(:new).and_return(payment_transactions_facade_double)
      allow(payment_transactions_facade_double)
        .to receive(:payment_transactions)
        .and_return(payment_transactions_result)
      allow(payment_transactions_facade_double)
        .to receive(:start_balance)
        .and_return(start_balance_result)
      allow(payment_transactions_facade_double)
        .to receive(:end_balance)
        .and_return(end_balance_result)
    end

    it "should work" do
      subject
      expect(response.status).to eq(200)
      expect(json_body)
        .to eq("data" => {
          "end_balance" => end_balance_result,
          "payment_transactions" => [
            { "amount" => payment_transaction.amount,
              "date" => payment_transaction.created_at.to_date.to_s,
              "name" => payment_transaction.name }
          ],
          "start_balance" => start_balance_result
        })
    end

    it "should use facade correctly" do
      subject
      expect(PaymentTransactionsFacade)
        .to have_received(:new)
        .with(user, params[:start_date], params[:end_date])
    end
  end

  describe "POST /api/v1/payment_transactions" do
    let(:params) { { "name" => "Test name", "amount" => 1000 } }
    let(:service_double) { double("PaymentTransactions::Create") }
    let(:success_result) { true }
    let!(:payment_transaction) { create(:payment_transaction, user: user) }
    let(:payment_transaction_result) { payment_transaction }

    subject do
      post("/api/v1/payment_transactions",
           params: params.to_json,
           headers: { "Authentication" => "Bearer #{token}",
                      "CONTENT_TYPE" => "application/json" })
    end

    before do
      allow(PaymentTransactions::Create)
        .to receive(:new).and_return(service_double)
      allow(service_double)
        .to receive(:payment_transaction)
        .and_return(payment_transaction_result)
      allow(service_double).to receive(:perform)
      allow(service_double)
        .to receive(:success)
        .and_return(success_result)
    end

    it "should work" do
      subject
      expect(response.status).to eq(201)
      expect(json_body)
        .to eq("data" => { "payment_transaction" => {
          "amount" => payment_transaction.amount,
          "date" => payment_transaction.created_at.to_date.to_s,
          "name" => payment_transaction.name } })
    end

    it "should use facade correctly" do
      subject
      expect(PaymentTransactions::Create)
        .to have_received(:new).with(params: params, user: user)
    end
  end
end
