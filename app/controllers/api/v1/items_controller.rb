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
    Item.destroy_invoices(params[:id])
    render json: Item.delete(params[:id])
  end

  def find
    if (params[:max_price] || params[:min_price]) && params[:name]
      return render status: :not_acceptable
    end

    item = Item.find_by_name_or_price(params)
    render json: ItemSerializer.new(item)
  end

  def find_all
    if (params[:max_price] || params[:min_price]) && params[:name]
      return render status: :not_acceptable
    end

    items = Item.find_all_by_name_or_price(params)
    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
