require 'rails_helper'

RSpec.describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get api_v1_merchants_path

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(merchants).to be_a Hash
    data = merchants[:data]
    expect(data).to be_an Array
    expect(data.count).to eq(3)
    expect(data).to all(have_key(:attributes))

    data.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'sends a single merchant' do
    merchant_obj = create(:merchant)
    get api_v1_merchant_path(merchant_obj)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(merchant_obj.id.to_s)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq('merchant')

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(merchant_obj.name)
  end

  it 'sends a merchants items' do
    merchant = create(:merchant) do |merchant|
      create_list(:item, 5, merchant: merchant)
    end

    get api_v1_merchant_items_path(merchant)
    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(items.length).to eq(5)
    items.each do |item|
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  it 'returns 404 if merchant id does not exist' do
    get api_v1_merchant_items_path(50)
    expect(response.status).to eq(404)
  end

  describe 'Search functions' do
    describe 'Find one' do
      it 'finds a merchant by name' do
        hagrid = create(:merchant, name: 'Hagrid')
        create_list(:merchant, 5)

        get find_api_v1_merchants_path(name: 'Hagrid')
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant[:data][:attributes][:name]).to eq(hagrid.name)
        expect(merchant[:data]).to be_a Hash
      end

      it 'Has partial matching' do
        hagrid = create(:merchant, name: 'Hagrid')
        create_list(:merchant, 5)

        get find_api_v1_merchants_path(name: 'Hag')
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant[:data][:attributes][:name]).to eq(hagrid.name)
        expect(merchant[:data]).to be_a Hash
      end

      it 'Searches are case-insensitive' do
        hagrid = create(:merchant, name: 'Hagrid')
        create_list(:merchant, 5)

        get find_api_v1_merchants_path(name: 'hAGRID')
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant[:data][:attributes][:name]).to eq(hagrid.name)
        expect(merchant[:data]).to be_a Hash
      end
    end

    describe 'Find all' do
      it 'finds multiple merchants by name' do
        hagrid = create(:merchant, name: 'Hagrid')
        gridlock = create(:merchant, name: 'Gridlock')
        create_list(:merchant, 5)

        get find_all_api_v1_merchants_path(name: 'grid')
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant[:data]).to be_an Array
        expect(merchant[:data].length).to eq(2)
      end
    end
  end
end
