# frozen_string_literal: true

class AddTokenAndBalanceToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.bigint :balance, null: false, default: 0
      t.string :token, null: false
    end

    add_index :users, :token, unique: true
  end
end
