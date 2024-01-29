# frozen_string_literal: true

class ReportController < ApplicationController
  def index
    @pagy, @bills = pagy(bills_query)

    respond_to do |format|
      format.html
      format.csv { send_data Bill.to_csv(@bills), filename: "bills-#{Date.today}.csv" }
    end
  end

  protected

  def bills_query
    Bill.includes(:shift)
        .joins(:shift)
        .where(shifts: { shift_date: from_date..to_date })
        .order('shifts.shift_date DESC')
  end

  def from_date
    helpers.query_attributes[:from]
  end

  def to_date
    helpers.query_attributes[:to]
  end
end
