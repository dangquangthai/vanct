# frozen_string_literal: true

class Voucher < ApplicationRecord
  belongs_to :shift

  KINDS = %w[payment receipt].freeze
end
