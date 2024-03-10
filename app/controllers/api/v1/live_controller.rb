# frozen_string_literal: true

module API
  module V1
    class LiveController < API::V1::BaseController
      before_action :require_customer!

      def create
        data = {
          shift: shift,
          tables: [],
          updated_at: Current.ftime
        }

        tables.each do |table|
          lines = table_lines.select { |table_line| table_line[:table_no] == table[:table_no] }
          data[:tables] << buil_table(table, lines)
        end

        Cache.write(@customer.live_data_key, data.to_json)

        json_response({ success: true })
      end

      protected

      def buil_table(table, lines)
        table[:lines] = lines
        table[:da_bao] = lines.size.positive? && lines.size == lines.count { |line| line[:da_bao] }
        discount = table[:discount] || 0
        table[:total] = lines.sum { |line| line[:total] || 0 } - discount
        table
      end

      def tables
        @tables ||= params
                    .permit(tables: %i[table_no
                                       busy
                                       has_change
                                       printed
                                       stt
                                       in_time
                                       out_time
                                       discount
                                       staff]).to_h['tables']
      end

      def table_lines
        @table_lines ||= params
                         .permit(table_lines: %i[table_no
                                                 product_name
                                                 product_no
                                                 amount
                                                 price
                                                 unit
                                                 product_group
                                                 order_time
                                                 da_bao
                                                 cabin
                                                 staff
                                                 total]).to_h['table_lines']
      end

      def shift
        @shift ||= params.require(:shift).permit(:total, :stt, :date, :no).to_h
      end
    end
  end
end
