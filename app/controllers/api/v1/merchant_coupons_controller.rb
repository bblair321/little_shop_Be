module Api
  module V1
    class MerchantCouponsController < ApplicationController
      before_action :set_merchant
      before_action :set_coupon, only: [:show]

      def index
        coupons = @merchant.coupons
        render json: {
          data: coupons.map { |coupon| format_coupon(coupon) }
        }, status: :ok
      end

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

      def set_merchant
        @merchant = Merchant.find(params[:merchant_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Merchant not found" }, status: :not_found
      end

      def set_coupon
        @coupon = @merchant.coupons.find(params[:id])
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
          used_count: @coupon.invoices.count
        }
      end

      def format_coupon(coupon)
        {
          id: coupon.id.to_s,
          type: "coupon",
          attributes: {
            name: coupon.name,
            code: coupon.code,
            discount_type: coupon.discount_type,
            discount_value: coupon.discount_value,
            active: coupon.active,
            used_count: coupon.invoices.count
          }
        }
      end
    end
  end
end