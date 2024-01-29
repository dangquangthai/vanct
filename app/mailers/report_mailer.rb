# frozen_string_literal: true

require 'csv'

class ReportMailer < ApplicationMailer
  def export
    @from_date = params[:from_date]
    @to_date = params[:to_date]
    to_email = params[:to_email]
    customer_id = params[:customer_id]
    @sum_shifts = Shift.where(shift_date: @from_date..@to_date, customer_id: customer_id).sum(:total)

    @bills = Bill.includes(:shift)
                 .joins(:shift)
                 .where(shifts: { shift_date: @from_date..@to_date })
                 .where(shifts: { customer_id: customer_id })
                 .order('shifts.shift_date DESC')

    file = CSV.generate(headers: true) do |csv|
      csv << %w[BILL BÀN NGÀY TỔNG]

      @bills.each do |bill|
        csv << [
          bill.bill_no,
          bill.table_no,
          bill.shift.shift_date.strftime('%d-%m-%y'),
          bill.total.to_f.round(0)
        ]
      end
    end

    attachments['bao_cao.csv'] = { mime_type: 'text/csv', content: file }

    mail(to: to_email, subject: 'Báo cáo doanh thu')
  end
end
