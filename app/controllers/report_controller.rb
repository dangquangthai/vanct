# frozen_string_literal: true

class ReportController < ApplicationController
  before_action :validate_customer_expired!

  def index
    @bills_pagy, @bills = pagy(report_builder.bills_query, page_param: :bill_page)
    @vouchers_pagy, @vouchers = pagy(report_builder.vouchers_query, page_param: :voucher_page)
    @chart_data = report_builder.perform

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
        send_data report_builder.to_csv_file, filename: "bao_cao_#{Time.current.to_i}.csv"
      end
    end
  end

  def export_form
    respond_to do |format|
      format.turbo_stream
    end
  end

  protected

  def report_builder
    @report_builder ||= ReportDataBuilder.new(from_date: from_date, to_date: to_date, bill_no: bill_no, table_no: table_no, v_kind: v_kind)
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

  def v_kind
    helpers.query_attributes[:v_kind]
  end
end
