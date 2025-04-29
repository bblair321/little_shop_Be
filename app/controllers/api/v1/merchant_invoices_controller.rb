module Api
  module V1
    class MerchantInvoicesController < ApplicationController
      before_action :set_merchant

      def index
        invoices = @merchant.invoices

        render json: {
          data: invoices.map { |invoice| format_invoice(invoice) }
        }, status: :ok
      end

      private

      def set_merchant
        @merchant = Merchant.find(params[:merchant_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: [e.message] }, status: :not_found
      end

      def format_invoice(invoice)
        {
          id: invoice.id.to_s,
          type: "invoice",
          attributes: {
            customer_id: invoice.customer_id.to_s,
            merchant_id: @merchant.id.to_s,
            coupon_id: invoice.coupon_id&.to_s,
            status: invoice.status
          }
        }
      end
    end
  end
end