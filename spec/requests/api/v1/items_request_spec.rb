require 'rails_helper'

RSpec.describe "Items API" do
  it 'sends a collection of items' do
    create_list(:item, 3)

    get api_v1_items_path

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)
    expect(items).to be_a Hash
    data = items[:data]
    expect(data).to be_an Array
    expect(data.count).to eq(3)
    expect(data).to all(have_key(:attributes))

    data.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      attributes = item[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)
    end
  end

  it 'sends a single item' do
    item_obj = create(:item)
    get api_v1_item_path(item_obj)
    item = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(item_obj.id.to_s)

    expect(item).to have_key(:type)
    expect(item[:type]).to eq('item')

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq(item_obj.name)
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = attributes_for(:item, merchant_id: merchant.id)
    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
  
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it "can update an existing item" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
    previous_price = Item.last.unit_price
    item_params = { unit_price: 147.83 }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)
    updated_item = Item.find(item.id)

    expect(response).to be_successful
    expect(updated_item.unit_price).to_not eq(previous_price)
    expect(updated_item.unit_price).to eq(147.83)
  end

  it "can destroy an item" do
    item = create(:item)

    expect{ delete api_v1_item_path(item.id) }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can get an item merchant' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get api_v1_item_merchant_path(item)
    merchant_response = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(merchant[:id]).to eq(merchant.id)
  end

  describe 'Search functions' do
    describe 'Find one' do
      it 'finds an item by name' do
        hagrid = create(:item, name: 'Hagrid')
        create_list(:item, 5)

        get find_api_v1_items_path(name: 'Hagrid')
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:attributes][:name]).to eq(hagrid.name)
        expect(item[:data]).to be_a Hash
      end

      it 'Has partial matching' do
        hagrid = create(:item, name: 'Hagrid')
        create_list(:item, 5)

        get find_api_v1_items_path(name: 'Hag')
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:attributes][:name]).to eq(hagrid.name)
        expect(item[:data]).to be_a Hash
      end

      it 'Searches are case-insensitive' do
        hagrid = create(:item, name: 'Hagrid')
        create_list(:item, 5)

        get find_api_v1_items_path(name: 'hAGRID')
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:attributes][:name]).to eq(hagrid.name)
        expect(item[:data]).to be_a Hash
      end

      it 'can find an item within a specified price range' do
        [*4..9].each { |price| create(:item, unit_price: price) }
        target_item = create(:item, unit_price: 5.50 )

        get find_api_v1_items_path(max_price: 5.99, min_price: 5.25)
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:attributes][:name]).to eq(target_item.name)
        expect(item[:data]).to be_a Hash
      end

      it 'returns an error when trying to search with both a name and a price range' do
        create_list(:item, 10)
        create(:item, unit_price: 5.50, name: 'Whatever' )

        get find_api_v1_items_path(max_price: 5.99, min_price: 5.25, name: 'Whatever')

        expect(response.status).to eq(400)
      end

      it 'returns a result when searching with just an upper or lower limit' do
        [*5..15].each { |price| create(:item, unit_price: price) }

        get find_api_v1_items_path(min_price: 15)
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:attributes][:unit_price]).to eq(15)

        get find_api_v1_items_path(max_price: 5)
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:attributes][:unit_price]).to eq(5)
      end
    end

    describe 'Find all' do
      it 'finds multiple items by name' do
        hagrid = create(:item, name: 'Hagrid')
        gridlock = create(:item, name: 'Gridlock')
        create_list(:item, 5)

        get find_all_api_v1_items_path(name: 'grid')
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data]).to be_an Array
        expect(item[:data].length).to eq(2)
      end

      it 'find items by min price' do
        [*4..9].each { |price| create(:item, unit_price: price) }

        get find_all_api_v1_items_path(min_price: 8)
        item = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(item[:data]).to be_an Array
        expect(item[:data].length).to eq(2)
      end

      it 'min price less than 0' do
        create_list(:item, 5)
        get find_all_api_v1_items_path(min_price: -1)
        parsed_response = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(400)
      end
    end
  end
end