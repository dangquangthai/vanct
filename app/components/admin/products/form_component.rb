# frozen_string_literal: true

module Admin
  module Products
    class FormComponent < ApplicationComponent
      def initialize(product:, url:, form_method:, form_title:)
        @product = product
        @url = url
        @form_method = form_method
        @form_title = form_title
      end

      attr_reader :product, :url, :form_method, :form_title
    end
  end
end
