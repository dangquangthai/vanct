# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :key, presence: true, uniqueness: true
  validates :name, :expires_at, presence: true

  def expired?
    expires_at < Time.current
  end

  def online?
    return false if last_seen_at.nil?

    last_seen_at > 5.minutes.ago
  end

  def update_last_see_at!
    update!(last_seen_at: Time.current) if last_seen_at > 4.minutes.ago
  end
end
