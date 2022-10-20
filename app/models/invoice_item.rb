class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.destroy_invoices(item_id)
    invoices_to_destroy = where('item_id = ?', item_id)
    .select('invoice_id, count(')
  end

  # Get invoice id's from records where the item id is the passed item id and that invoice does not have any other items
end
