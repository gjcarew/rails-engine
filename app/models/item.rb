class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_by_name_or_price(params)
    return find_one(params[:name]) if params[:name] # Guard clause if name present

    price_more_than(params[:min_price]) # Activerecord query using scopes
      .price_less_than(params[:max_price])
      .first
  end

  def self.find_all_by_name_or_price(params)
    return find_all(params[:name]) if params[:name]

    price_more_than(params[:min_price])
      .price_less_than(params[:max_price])
  end

  scope :price_more_than, lambda { |price|
    where('unit_price >= ?', price) if price.present?
  }

  scope :price_less_than, lambda { |price|
    where('unit_price <= ?', price) if price.present?
  }
end
