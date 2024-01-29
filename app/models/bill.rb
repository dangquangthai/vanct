# frozen_string_literal: true

class Bill < ApplicationRecord
  belongs_to :shift
  has_many :bill_lines, dependent: :destroy
end
