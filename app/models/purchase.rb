# frozen_string_literal: true

class Purchase < ApplicationRecord
  belongs_to :shift

  has_many :purchase_lines, dependent: :destroy
end
