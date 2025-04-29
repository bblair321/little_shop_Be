class MerchantSerializer
  include JSONAPI::Serializer
  
  attributes :name

  attribute :item_count, if: proc { |_record, params|
    params && params[:include_item_count]
  } do |merchant|
    merchant.item_count
  end

  attribute :coupons_count do |merchant|
    merchant.coupons.count
  end

  attribute :invoice_coupon_count do |merchant|
    merchant.invoices.where.not(coupon_id: nil).count
  end
end