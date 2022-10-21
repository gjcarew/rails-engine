require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'instance methods' do
    it '#destroy_invoices' do
      item = create(:item)
      item2 = create(:item)
      invoices = create_list(:invoice, 4)
      create(:invoice_item, invoice_id: invoices[0].id, item_id: item.id)
      create(:invoice_item, invoice_id: invoices[1].id, item_id: item.id)
      create(:invoice_item, invoice_id: invoices[2].id, item_id: item.id)
      create(:invoice_item, invoice_id: invoices[3].id, item_id: item.id)
      create(:invoice_item, invoice_id: invoices[0].id, item_id: item2.id)
      create(:invoice_item, invoice_id: invoices[1].id, item_id: item2.id)

      item.invoices.each { |invoice| invoice.destroy_invoices }

      expect(Invoice.all).to eq([invoices[0], invoices[1]])
    end
  end
end