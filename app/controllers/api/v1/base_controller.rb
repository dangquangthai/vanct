# frozen_string_literal: true

module API
  module V1
    class BaseController < ActionController::API
      protected

      def require_tenant!
        @tenant = Tenant.find_by!(key: params[:key])
      end

      rescue_from StandardError,                      with: :internal_server_error
      rescue_from ActiveRecord::RecordNotFound,       with: :not_found
      rescue_from ActiveRecord::RecordInvalid,        with: :unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :bad_request

      def json_response(object, status = :ok)
        render json: object, status: status
      end

      def internal_server_error(execption)
        Rails.logger.error(execption)
        json_response({ success: false, message: execption.message }, :internal_server_error)
      end

      def bad_request
        json_response({ success: false, message: 'Parameter missing' }, :bad_request)
      end

      def not_found
        json_response({ success: false, message: 'Resource not found' }, :not_found)
      end

      def unprocessable_entity(exception)
        json_response({ success: false, message: exception.message }, :unprocessable_entity)
      end
    end
  end
end
