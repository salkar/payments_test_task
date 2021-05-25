# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  include Authentication

  attr_reader :current_user
end
