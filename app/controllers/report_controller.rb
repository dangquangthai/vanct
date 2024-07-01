# frozen_string_literal: true

class ReportController < ApplicationController
  before_action :validate_tenant_expired!
  before_action :validate_tenant_sync_data!

  def index
    load_bills
    load_vouchers
    load_inventories
    load_purchases
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

  def load_bills
    @bills_pagy, @bills = pagy(report_builder.bills_query, page_param: :bill_page, items: 10)
    @bill_lines_pagy, @bill_lines = pagy(report_builder.bill_lines_query, page_param: :bill_line_page, items: 10)
  end

  def load_vouchers
    return unless current_tenant.sync_voucher?

    @vouchers_pagy, @vouchers = pagy(report_builder.vouchers_query, page_param: :voucher_page, items: 10)
  end

  def load_inventories
    return unless current_tenant.sync_inventory?

    @inventories_pagy, @inventories = pagy(report_builder.inventories_query, page_param: :inventory_page, items: 10)
  end

  def load_purchases
    return unless current_tenant.sync_purchase?

    @purchases_pagy, @purchases = pagy(report_builder.purchases_query, page_param: :purchase_page, items: 10)
    @providers_pagy, @providers = pagy(report_builder.providers_query, page_param: :provider_page, items: 10)
  end

  def report_builder
    @report_builder ||= ReportDataBuilder.new(from_date: from_date, to_date: to_date, bill_no: bill_no, table_no: table_no, v_kind: v_kind, provider_name: provider_name)
  end

  def provider_name
    helpers.query_attributes[:provider_name]
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
    helpers.query_attributes.fetch(:v_kind, 'payment')
  end
end
