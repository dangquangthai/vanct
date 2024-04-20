# frozen_string_literal: true

class PurchaseLine < ApplicationRecord
  belongs_to :purchase
end
