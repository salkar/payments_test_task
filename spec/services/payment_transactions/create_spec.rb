# frozen_string_literal: true

RSpec.describe PaymentTransactions::Create do
  let(:amount) { 2000 }
  let(:name) { "Test name" }
  let(:params) do
    HashWithIndifferentAccess.new(amount: amount, name: name)
  end
  let(:balance) { 1000 }
  let(:user) { create(:user, balance: balance) }
  let(:service) { described_class.new(params: params, user: user) }
  subject { service.perform }

  it do
    expect(subject).to be_truthy
  end

  context "balance" do
    it "should be changed correctly" do
      expect { subject }
        .to change { user.balance }.from(balance).to(balance + amount)
    end
  end

  context "payment transactions" do
    it "should be created correctly" do
      expect { subject }.to change { PaymentTransaction.count }.from(0).to(1)
      payment_transaction = PaymentTransaction.last
      expect(payment_transaction.amount).to eq(amount)
      expect(payment_transaction.balance).to eq(amount + balance)
      expect(payment_transaction.name).to eq(name)
      expect(payment_transaction.user).to eq(user)
    end
  end

  context "if payment transaction validation failed" do
    let(:name) { nil }

    it "should return errors" do
      expect(subject).to be_falsey
      expect(service.errors.details).to eq(name: [{ error: :blank }])
      expect(user.reload.balance).to eq(balance)
      expect(PaymentTransaction.count).to eq(0)
    end
  end

  context "if amount == 0" do
    let(:amount) { 0 }

    it "should return errors" do
      expect(subject).to be_falsey
      expect(service.errors.details)
        .to eq(amount: [{ error: :other_than, value: 0, count: 0 }])
      expect(user.reload.balance).to eq(balance)
      expect(PaymentTransaction.count).to eq(0)
    end
  end

  context "if amount < 0 and balance is sufficient" do
    let(:amount) { -999 }

    it do
      expect(subject).to be_truthy
    end

    context "balance" do
      it "should be changed correctly" do
        expect { subject }
          .to change { user.balance }.from(balance).to(balance + amount)
      end
    end

    context "payment transactions" do
      it "should be created correctly" do
        expect { subject }.to change { PaymentTransaction.count }.from(0).to(1)
        payment_transaction = PaymentTransaction.last
        expect(payment_transaction.amount).to eq(amount)
        expect(payment_transaction.balance).to eq(amount + balance)
      end
    end
  end

  context "if amount < 0 and balance is not sufficient" do
    let(:amount) { -1001 }

    it "should return errors" do
      expect(subject).to be_falsey
      expect(service.errors.details)
        .to eq(amount: [{ error: :not_enough_balance }])
      expect(user.reload.balance).to eq(balance)
      expect(PaymentTransaction.count).to eq(0)
    end
  end

  context "concurrency" do
    let(:amount) { -1001 }

    before do
      allow(service).to receive(:check_amount)
    end

    it do
      expect(subject).to be_falsey
      expect(user.reload.balance).to eq(balance)
      expect(PaymentTransaction.count).to eq(0)
    end
  end
end
