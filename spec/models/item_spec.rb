require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'instance methods' do
    describe '#self.find_by_name_or_price' do
      it 'searches by name if name present' do
        item = create(:item, name: 'item A')
        create_list(:item, 5)
        params = { name: 'item A' }
        result = Item.find_by_name_or_price(params)
        expect(result.first).to eq(item)
      end

      it 'searches by min/max price if present' do
        [*1..10].each { |n| create(:item, unit_price: n) }
        params1 = { min_price: 10 }
        params2 = { max_price: 1 }
        params3 = { min_price: 4.5, max_price: 5.5 }
        result1 = Item.find_by_name_or_price(params1)
        result2 = Item.find_by_name_or_price(params2)
        result3 = Item.find_by_name_or_price(params3)

        expect(result1.first.unit_price).to eq(10)
        expect(result2.first.unit_price).to eq(1)
        expect(result3.first.unit_price).to eq(5)
      end
    end

    describe '#find_all_by_name_or_price' do
      describe '#self.find_by_name_or_price' do
        it 'searches by name if name present' do
          item = create(:item, name: 'deathbringer')
          item2 = create(:item, name: 'Kris Kringle')
          create_list(:item, 5)
          params = { name: 'ring' }
          result = Item.find_by_name_or_price(params)
          expect(result).to eq([item, item2])
        end
  
        it 'searches by min/max price if present' do
          [*1..10].each { |n| create(:item, unit_price: n) }
          params1 = { min_price: 8 }
          params2 = { max_price: 4 }
          params3 = { min_price: 2, max_price: 6 }
          result1 = Item.find_by_name_or_price(params1)
          result2 = Item.find_by_name_or_price(params2)
          result3 = Item.find_by_name_or_price(params3)
  
          expect(result1.length).to eq(3)
          expect(result2.length).to eq(4)
          expect(result3.length).to eq(5)
        end
      end
    end
  end
end
