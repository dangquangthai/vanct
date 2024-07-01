# frozen_string_literal: true

module Admin
  class ShiftsController < BaseController
    before_action :authorize_admin!
    before_action :require_tenant!
    before_action :search_shifts

    def index
      respond_to do |format|
        format.html
      end
    end

    def destroy_all
      respond_to do |format|
        format.turbo_stream do
          @shifts.destroy_all.map(&:queue_update_to_desktop)
        end
      end
    end

    protected

    def search_shifts
      @shifts = @tenant.shifts.where(shift_date: from_date..to_date)
    end

    def from_date
      helpers.query_attributes[:from]
    end

    def to_date
      helpers.query_attributes[:to]
    end
  end
end
