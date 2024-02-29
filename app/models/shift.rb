# frozen_string_literal: true

class Shift < ApplicationRecord
  belongs_to :customer
  has_many :bills, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :inventories, dependent: :destroy
end
