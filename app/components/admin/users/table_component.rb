# frozen_string_literal: true

module Admin
  module Users
    class TableComponent < ApplicationComponent
      def initialize(users:, tenant:)
        @users = users
        @tenant = tenant
      end

      attr_reader :users, :tenant
    end
  end
end
