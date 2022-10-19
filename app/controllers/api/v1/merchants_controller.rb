class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find
    merchant = Merchant.find_one(params[:name])
    render json: MerchantSerializer.new(merchant)
  end

  def find_all
    merchants = Merchant.find_all(params[:name])
    render json: MerchantSerializer.new(merchants)
  end
end