# frozen_string_literal: true

class BillLine < ApplicationRecord
  belongs_to :bill
end
