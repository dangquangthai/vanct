# frozen_string_literal: true

module Admin
  module Users
    class TableComponent < ApplicationComponent
      def initialize(users:, customer:)
        @users = users
        @customer = customer
      end

      attr_reader :users, :customer
    end
  end
end
