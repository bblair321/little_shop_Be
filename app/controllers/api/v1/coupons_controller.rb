class CouponsController < ApplicationController
  before_action :set_coupon, only: [:show]

  def show
    render json: {
      data: {
        id: @coupon.id.to_s,
        type: "coupon",
        attributes: coupon_attributes
      }
    }
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Coupon not found" }, status: :not_found
  end

  def coupon_attributes
    {
      name: @coupon.name,
      code: @coupon.code,
      discount_type: @coupon.discount_type,
      discount_value: @coupon.discount_value,
      active: @coupon.active,
      merchant_id: @coupon.merchant_id,
      used_count: @coupon.invoices.count # count how many times the coupon has been used in invoices
    }
  end
end