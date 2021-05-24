# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`balance`**     | `bigint`           | `default(0), not null`
# **`token`**       | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_users_on_token` (_unique_):
#     * **`token`**
#
class User < ApplicationRecord
  has_secure_token

  has_many :payment_transactions, dependent: :restrict_with_error
end
