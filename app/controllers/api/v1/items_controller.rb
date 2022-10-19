class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    @item.update!(item_params)
    render json: ItemSerializer.new(@item)
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
  end

  def set_item
    @item = Item.find(params[:id])
  end

end