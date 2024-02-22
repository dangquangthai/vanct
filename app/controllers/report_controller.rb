# frozen_string_literal: true

class ReportController < ApplicationController
  before_action :validate_customer_expired!

  def index
    @pagy, @bills = pagy(bills_query)
    @chart_data = build_chart_data

    respond_to do |format|
      format.html
    end
  end

  def show
    @bill = Bill.find(params[:bill_id])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def download_csv
    respond_to do |format|
      format.csv do
        send_data csv_file, filename: "bao_cao_#{Time.current.to_i}.csv"
      end
    end
  end

  def export_form
    respond_to do |format|
      format.turbo_stream
    end
  end

  def export
    to_email = params.require(:export).permit(:email)[:email]

    ReportMailer.with(
      from_date: from_date,
      to_date: to_date,
      to_email: to_email,
      customer_id: current_user.customer.id
    ).export.deliver_now

    respond_to do |format|
      format.turbo_stream
    end
  end

  protected

  def csv_file
    CSV.generate(headers: true) do |csv|
      csv << %w[BILL BÀN NGÀY TỔNG]

      bills_query.each do |bill|
        csv << [
          bill.bill_no,
          bill.table_no,
          bill.shift.shift_date.strftime('%d-%m-%y'),
          bill.total.to_f.round(0)
        ]
      end
    end
  end

  def build_chart_data
    shifts = current_user.customer.shifts.where(shift_date: from_date..to_date).select('shift_date').group('shift_date').order('shift_date ASC')
    totals = shifts.sum('total')
    bg_colors = totals.map { sample_colors.sample }
    border_colors = bg_colors.map { |color| color.gsub(/, 0\.2\)/, ', 1)') }
    @sum_shifts = totals.sum { |_, total| total }
    {
      labels: totals.map { |date, _| date.strftime('%d/%m') },
      datasets: [
        {
          data: totals.map { |_, total| total.to_i / 1000 },
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
    bills = Bill.includes(:shift)
                .joins(:shift)
                .where(shifts: { shift_date: from_date..to_date })
                .where(shifts: { customer_id: current_user.customer.id })
    bills = bills.where(bill_no: bill_no) if bill_no.present?
    bills = bills.where(table_no: table_no) if table_no.present?
    bills.order('shifts.shift_date DESC, bills.bill_no DESC')
  end

  def bill_no
    helpers.query_attributes[:bill_no]
  end

  def table_no
    helpers.query_attributes[:table_no]
  end

  def from_date
    helpers.query_attributes[:from]
  end

  def to_date
    helpers.query_attributes[:to]
  end
end
