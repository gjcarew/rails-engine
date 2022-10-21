class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  def find
    merchant = find_merchant_or_404(params)
    return render json: { 'data': {} }, status: :not_found if merchant.nil?

    if merchant.is_a?(String)
      render json: MerchantSerializer.error(merchant), status: :bad_request
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  def find_all
    merchant = find_all_merchant_or_404(params)
    return render json: { 'data': {} }, status: :not_found if merchant.nil?

    if merchant.is_a?(String)
      render json: MerchantSerializer.error(merchant), status: :bad_request
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  private

  def find_merchant_or_404(params)
    until params[:name].present? && params[:name] != ''
      return 'search term required'
    end
    
    Merchant.find_one(params[:name])
  end

  def find_all_merchant_or_404(params)
    until params[:name].present? && params[:name] != ''
      return 'search term required'
    end
    
    Merchant.find_all(params[:name])
  end
end