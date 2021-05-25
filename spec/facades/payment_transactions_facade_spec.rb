# frozen_string_literal: true

RSpec.describe PaymentTransactionsFacade do
  let(:user) { create(:user) }
  let(:start_date) { "2021-05-21" }
  let(:end_date) { "2021-05-23" }
  subject { described_class.new(user, start_date, end_date) }

  around do |example|
    Time.use_zone("UTC") { example.run }
  end

  let!(:payment_transaction) do
    create(:payment_transaction, user: user,
           amount: 1000, balance: 1000, created_at: "2021-05-18 23:00:00 UTC")
  end
  let!(:payment_transaction_1) do
    create(:payment_transaction, user: user,
           amount: 3000, balance: 4000, created_at: "2021-05-19 18:00:00 UTC")
  end
  let!(:payment_transaction_2) do
    create(:payment_transaction, user: user,
           amount: -800, balance: 3200, created_at: "2021-05-21 00:00:00 UTC")
  end
  let!(:payment_transaction_3) do
    create(:payment_transaction, user: user,
           amount: -1000, balance: 2200, created_at: "2021-05-23 23:00:00 UTC")
  end
  let!(:payment_transaction_4) do
    create(:payment_transaction, user: user,
           amount: 1500, balance: 3700, created_at: "2021-05-24 00:00:00 UTC")
  end

  context "if results between other data" do
    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions)
          .to eq([payment_transaction_2, payment_transaction_3])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(4000)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(2200)
      end
    end
  end

  context "if results between other data but have no data" do
    let(:start_date) { "2021-05-22" }
    let(:end_date) { "2021-05-22" }

    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions).to eq([])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(3200)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(3200)
      end
    end
  end

  context "if results before other data" do
    let(:start_date) { "2021-05-14" }
    let(:end_date) { "2021-05-16" }

    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions).to eq([])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(0)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(0)
      end
    end
  end

  context "if results after data" do
    let(:start_date) { "2021-05-25" }
    let(:end_date) { "2021-05-27" }

    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions).to eq([])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(3700)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(3700)
      end
    end
  end

  context "without start date" do
    let(:start_date) { nil }
    let(:end_date) { "2021-05-19" }

    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions)
          .to eq([payment_transaction, payment_transaction_1])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(0)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(4000)
      end
    end
  end

  context "without end date" do
    let(:start_date) { "2021-05-23" }
    let(:end_date) { nil }

    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions)
          .to eq([payment_transaction_3, payment_transaction_4])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(3200)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(3700)
      end
    end
  end

  context "without start and end dates" do
    let(:start_date) { nil }
    let(:end_date) { nil }

    describe "#payment_transactions" do
      it do
        expect(subject.payment_transactions)
          .to eq([payment_transaction, payment_transaction_1,
                  payment_transaction_2, payment_transaction_3,
                  payment_transaction_4])
      end
    end

    describe "#start_balance" do
      it do
        expect(subject.start_balance).to eq(0)
      end
    end

    describe "#end_balance" do
      it do
        expect(subject.end_balance).to eq(3700)
      end
    end
  end
end
