# frozen_string_literal: true

module Admin
  module Users
    class TableComponent < ApplicationComponent
      def initialize(users:)
        @users = users
      end

      attr_reader :users
    end
  end
end
