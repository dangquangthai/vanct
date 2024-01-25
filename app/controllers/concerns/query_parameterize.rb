# frozen_string_literal: true

module QueryParameterize
  extend ActiveSupport::Concern

  included do
    def filter_params
      params.permit(:page, :per_page, q: {}).to_h.deep_symbolize_keys
    end

    def query_params
      filter_params.fetch(:q, {})
    end
  end
end
