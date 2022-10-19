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
end