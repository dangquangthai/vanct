# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :registerable, :rememberable, :recoverable
  devise :database_authenticatable, :validatable

  ROLES = %w[admin manager staff].freeze

  belongs_to :customer

  validates :role, inclusion: { in: ROLES }
  validates :username, uniqueness: true
  validates :password, presence: true, on: :create

  before_validation on: :create do
    self.email = "#{username}@vanct.com"
  end

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def staff?
    role == 'staff'
  end

  def role_humanize
    I18n.t("users.roles.#{role}")
  end
end
