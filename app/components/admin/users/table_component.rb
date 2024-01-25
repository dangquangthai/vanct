# frozen_string_literal: true

class Admin::Users::TableComponent < ApplicationComponent
  def initialize(users:)
      @users = users
    end

    attr_reader :users
end
