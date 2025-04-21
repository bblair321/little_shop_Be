class Merchant < ApplicationRecord
has_many :items, dependent: :destroy
has_many :invoices
validates_presence_of :name


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