# frozen_string_literal: true

module Admin
  module Settings
    class FormComponent < ApplicationComponent
      def initialize(setting:, url:, form_method:, form_title:)
        @setting = setting
        @url = url
        @form_method = form_method
        @form_title = form_title
      end

      attr_reader :setting, :url, :form_method, :form_title
    end
  end
end
