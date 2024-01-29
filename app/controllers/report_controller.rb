# frozen_string_literal: true

class ReportController < ApplicationController
  def index
    @pagy, @bills = pagy(bills_query)
    @shifts = current_user.customer.shifts.where(shifts: { shift_date: from_date..to_date }).order('shifts.shift_date ASC')
    @sum_shifts = @shifts.sum(:total)
    @chart_data = build_chart_data

    respond_to do |format|
      format.html
    end
  end

  protected

  def build_chart_data
    bg_colors = @shifts.map { sample_colors.sample }
    border_colors = bg_colors.map { |color| color.gsub(/, 0\.2\)/, ', 1)') }

    {
      labels: @shifts.map { |shift| shift.shift_date.strftime('%d/%m') },
      datasets: [
        {
          data: @shifts.map { |s| s.total / 1000 },
          backgroundColor: bg_colors,
          borderColor: border_colors,
          borderWidth: 1
        }
      ]
    }
  end

  def sample_colors
    [
      'rgba(255, 99, 132, 0.2)',
      'rgba(54, 162, 235, 0.2)',
      'rgba(255, 206, 86, 0.2)',
      'rgba(75, 192, 192, 0.2)',
      'rgba(153, 102, 255, 0.2)',
      'rgba(255, 159, 64, 0.2)'
    ]
  end

  def bills_query
    Bill.includes(:shift)
        .joins(:shift)
        .where(shifts: { shift_date: from_date..to_date })
        .where(shifts: { customer_id: current_user.customer.id })
        .order('shifts.shift_date DESC')
  end

  def from_date
    helpers.query_attributes[:from]
  end

  def to_date
    helpers.query_attributes[:to]
  end
end
