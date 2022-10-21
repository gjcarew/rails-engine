class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.where(id: params[:merchant_id])
    return render json: { 'error': {} }, status: :not_found if merchant.empty?

    items = Item.where(merchant_id: params[:merchant_id])
    render json: ItemSerializer.new(items)
  end
end
