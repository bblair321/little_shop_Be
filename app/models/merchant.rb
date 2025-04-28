class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :coupons, dependent: :destroy

  validates_presence_of :name
  validate :merchant_cannot_have_more_than_five_active_coupons, on: :create

  def merchant_cannot_have_more_than_five_active_coupons
    if coupons.where(active: true).count >= 5
      errors.add(:coupons, "cannot have more than 5 active coupons")
    end
  end

  def self.search_by_name(name)
    where('lower(name) ILIKE ?', "%#{name.downcase}%")
  end

  def self.search(params)
    if params[:name].present?
      search_by_name(params[:name])
    elsif params[:all]
      all.order(:name)
    else
      none
    end
  end

  def self.sorted_by_created_at(order = "desc")
    %w[asc desc].include?(order.downcase) ? order(created_at: order.downcase) : all
  end

  def self.with_returned_items
    joins(items: { invoice_items: :invoice })
      .where(invoices: { status: 'returned' })
      .distinct
  end

  def self.with_item_counts
     left_joins(:items)
      .select("merchants.*, COUNT(DISTINCT items.id) AS item_count")
      .group("merchants.id")
  end

  def item_count
    self[:item_count] || items.count
  end
end