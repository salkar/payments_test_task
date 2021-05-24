# frozen_string_literal: true

# ## Schema Information
#
# Table name: `payment_transactions`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`amount`**      | `bigint`           | `not null`
# **`balance`**     | `bigint`           | `not null`
# **`name`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_payment_transactions_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#
FactoryBot.define do
  factory :payment_transaction do
    amount { 100 }
    balance { 0 }
    name { Faker::Lorem.word }
    user
  end
end
