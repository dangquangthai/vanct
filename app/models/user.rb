# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable, :rememberable, :recoverable
  devise :database_authenticatable, :validatable

  ROLES = %w[admin user owner].freeze

  def admin?
    role == 'admin'
  end
end
