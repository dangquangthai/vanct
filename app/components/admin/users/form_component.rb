# frozen_string_literal: true

module Admin
  module Users
    class FormComponent < ApplicationComponent
      def initialize(user:, url:, form_method:, form_title:)
        @user = user
        @url = url
        @form_method = form_method
        @form_title = form_title
      end

      attr_reader :user, :url, :form_method, :form_title

      def roles_collection
        (User::ROLES - ['admin']).map { |role| [I18n.t("users.roles.#{role}"), role] }
      end
    end
  end
end
