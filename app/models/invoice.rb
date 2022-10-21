class Invoice < ApplicationRecord
  has_many :invoice_items, dependent: :delete_all
  has_many :items, through: :invoice_items

  def destroy_invoices
    destroy if items.count <= 1
  end
end
