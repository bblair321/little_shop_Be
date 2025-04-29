module Api
  module V1
    class CouponsController < ApplicationController
      before_action :set_coupon, only: [:show, :deactivate, :activate]  # Add :activate here

      def index
        merchant = Merchant.find(params[:merchant_id])
        coupons = merchant.coupons
      
        render json: {
          data: coupons.map do |coupon|
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
        }
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

      def activate
        if @coupon.update(active: true)
          render json: {
            data: format_coupon(@coupon)
          }, status: :ok
        else
          render json: { error: "Failed to activate coupon" }, status: :unprocessable_entity
        end
      end

      def deactivate
        if @coupon.update(active: false)
          render json: {
            data: format_coupon(@coupon)
          }, status: :ok
        else
          render json: { error: "Failed to deactivate coupon" }, status: :unprocessable_entity
        end
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
          used_count: @coupon.invoices.count
        }
      end

      def format_coupon(coupon)
        {
          id: coupon.id.to_s,
          type: "coupon",
          attributes: coupon_attributes
        }
      end
    end
  end
end