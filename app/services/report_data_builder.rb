# frozen_string_literal: true

require 'csv'

class ReportDataBuilder
  def initialize(from_date:, to_date:, bill_no:, table_no:, v_kind:)
    @from_date = from_date
    @to_date = to_date
    @bill_no = bill_no
    @table_no = table_no
    @v_kind = v_kind
  end

  attr_reader :to_date, :from_date, :bill_no, :table_no, :v_kind

  delegate :current_user, :current_customer, to: Current

  def perform
    bg_colors = shifts_and_totals.map { sample_colors.sample }
    border_colors = bg_colors.map { |color| color.gsub(/, 0\.2\)/, ', 1)') }

    {
      labels: shifts_and_totals.map { |date, _| date.strftime('%d/%m') },
      datasets: [
        {
          data: shifts_and_totals.map { |_, total| total.to_i / 1000 },
          backgroundColor: bg_colors,
          borderColor: border_colors,
          borderWidth: 1
        }
      ]
    }
  end

  def to_csv_file
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

  def sum_shifts
    @sum_shifts ||= shifts_and_totals.sum { |_, total| total }
  end

  def shifts_and_totals
    @shifts_and_totals ||= current_customer
                           .shifts
                           .where(shift_date: from_date..to_date)
                           .select('shift_date')
                           .group('shift_date')
                           .order('shift_date ASC')
                           .sum('total')
  end

  def inventories_query
    latest_shift = current_customer.shifts.where(shift_date: from_date..to_date).order(:id).last
    return latest_shift.inventories if latest_shift.present?
    
    Inventory.none
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

  def vouchers
    Voucher.includes(:shift)
           .joins(:shift)
           .where(shifts: { shift_date: from_date..to_date })
           .where(shifts: { customer_id: current_customer.id })
  end

  def vouchers_query
    v = vouchers
    v = v.where(kind: v_kind) if v_kind.present?
    v.order('shifts.shift_date DESC, vouchers.no DESC')
  end

  def sum_payment_vouchers
    @sum_payment_vouchers ||= vouchers.where(kind: :payment).sum(:total)
  end

  def sum_receipt_vouchers
    @sum_receipt_vouchers ||= vouchers.where(kind: :receipt).sum(:total)
  end

  def bills_query
    @bills_query ||= begin
      bills = Bill.includes(:shift)
                  .joins(:shift)
                  .where(shifts: { shift_date: from_date..to_date })
                  .where(shifts: { customer_id: current_customer.id })
      bills = bills.where(bill_no: bill_no) if bill_no.present?
      bills = bills.where(table_no: table_no) if table_no.present?
      bills.order('shifts.shift_date DESC, bills.bill_no DESC')
    end
  end

  def bill_lines_query
    BillLine.select('*').from(
      BillLine.select('count(bill_lines.id) as id, bill_lines.product_no, bill_lines.product_name, bill_lines.unit, bill_lines.price, sum(bill_lines.amount) as amount, sum(bill_lines.total) as total')
        .joins('INNER JOIN bills ON bill_lines.bill_id = bills.id')
        .joins('INNER JOIN shifts ON bills.shift_id = shifts.id')
        .where(shifts: { shift_date: from_date..to_date })
        .where(shifts: { customer_id: current_customer.id })
        .group('bill_lines.product_no, bill_lines.product_name, bill_lines.unit, bill_lines.price')
    ).order('amount DESC')
  end
end
