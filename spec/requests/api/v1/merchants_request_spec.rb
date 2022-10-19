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

  # xit 'sends a merchants items' do

  # end
end