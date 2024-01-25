# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :key, presence: true, uniqueness: true
  validates :name, :expires_at, presence: true

  def expired?
    expires_at < Time.current
  end
end
