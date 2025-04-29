require 'rails_helper'

RSpec.describe 'Api::V1::MerchantCoupons', type: :request do
  describe 'GET /api/v1/merchants/:merchant_id/coupons' do
    it 'returns a list of coupons' do
      merchant = create(:merchant)
      create(:coupon, merchant: merchant, code: 'ABC123')
      create(:coupon, merchant: merchant, code: 'DEF456')

      get "/api/v1/merchants/#{merchant.id}/coupons"

      expect(response).to be_successful

      coupons = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(coupons.count).to eq(2)
      expect(coupons.first[:attributes]).to have_key(:code)
    end
  end
end