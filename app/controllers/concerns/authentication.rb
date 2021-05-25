# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!

    def authenticate_user!
      _str, token = request.headers["Authentication"]&.split(" ")
      user = User.find_by(token: token)
      if user
        @current_user = user
      else
        head :unauthorized
      end
    end
  end
end
