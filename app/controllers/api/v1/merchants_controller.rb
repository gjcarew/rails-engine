class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if Merchant.exists?(params[:id])
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    else
      render status: :not_found
    end
  end

  def find
    merchant = find_merchant_or_404(params)
    merchant = merchant.first if merchant.is_a?(ActiveRecord::Relation)
    return render json: { 'data': {} }, status: :not_found if merchant.nil?

    if merchant.is_a?(String)
      render json: MerchantSerializer.error(merchant), status: :bad_request
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  def find_all
    merchant = find_merchant_or_404(params)
    return render json: { 'data': {} }, status: :not_found if merchant.nil?

    if merchant.is_a?(String)
      render json: MerchantSerializer.error(merchant), status: :bad_request
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  private

  def find_merchant_or_404(params)
    return 'search term required' unless params[:name].present? && params[:name] != ''

    Merchant.find_by_name(params[:name])
  end
end
