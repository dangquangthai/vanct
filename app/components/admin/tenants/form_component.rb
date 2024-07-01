# frozen_string_literal: true

module Admin
  module Tenants
    class FormComponent < ApplicationComponent
      def initialize(tenant:, url:, form_method:, form_title:)
        @tenant = tenant
        @url = url
        @form_method = form_method
        @form_title = form_title
      end

      attr_reader :tenant, :url, :form_method, :form_title
    end
  end
end
