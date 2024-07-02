# frozen_string_literal: true

module Admin
  module Customers
    class FormComponent < ApplicationComponent
      def initialize(customer:, url:, form_method:, form_title:)
        @customer = customer
        @url = url
        @form_method = form_method
        @form_title = form_title
      end

      attr_reader :customer, :url, :form_method, :form_title
    end
  end
end
