FactoryBot.define do
  factory :coupon do
    name { "10% Off" }
    code { "TENOFF" }
    discount_type { "percent_off" }
    discount_value { 10 }
    active { true }
    association :merchant
  end
end