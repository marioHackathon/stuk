# frozen_string_literal: true

class User < ApplicationRecord
  has_many :machines, through: :user_machines
  has_many :user_machines

  before_create :complete_registration

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :two_factor_authenticatable,
         otp_secret_encryption_key: 'hsfdbbhsjhdbndn&&6GFF87654678r90hbvgfcxvGF'

  def activate_otp
    self.otp_required_for_login = true
    self.otp_secret = unconfirmed_otp_secret
    self.unconfirmed_otp_secret = nil
    save!
  end

  def deactivate_otp
    self.otp_required_for_login = false
    self.otp_secret = nil
    save!
  end

  def complete_registration
    self.role = 'estudiante'
    self.salt = SecureRandom.hex
  end

  def admin?
    role == 'admin'
  end
end
