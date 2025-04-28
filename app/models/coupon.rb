class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum discount_type: { percent_off: 0, dollar_off: 1 }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount_type, presence: true
  validates :discount_value, presence: true, numericality: { greater_than: 0 }

  validate :merchant_cannot_have_more_than_five_active_coupons, on: :create

  private

  def merchant_cannot_have_more_than_five_active_coupons
    if active? && merchant.coupons.where(active: true).count >= 5
      errors.add(:base, "Merchant cannot have more than 5 active coupons.")
    end
  end
end