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
    @item.assign_attributes(item_params)
    if @item.save
      render json: ItemSerializer.new(@item)
    else
      render status: :bad_request
    end
  end

  def destroy
    # InvoiceItem.destroy_invoices(params[:id])
    render json: Item.delete(params[:id])
  end

  def find
    item = find_item_or_404(params)
    if item.is_a?(String)
      render json: ItemSerializer.error(item), status: :bad_request
    else
      render json: ItemSerializer.new(item)
    end
  end

  def find_all
    items = find_all_items_or_404(params)
    if items.is_a?(String)
      render json: ItemSerializer.error(items), status: :bad_request
    else
      render json: ItemSerializer.new(items)
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def find_item_or_404(params)
    return "can't filter by name and price" if (params[:max_price] || params[:min_price]) && params[:name]
    return 'max price must be >= 0' if params[:max_price].present? && params[:max_price].to_f <= 0
    return 'min price must be >= 0' if params[:min_price].present? && params[:min_price].to_f <= 0

    Item.find_by_name_or_price(params)
  end

  def find_all_items_or_404(params)
    return "can't filter by name and price" if (params[:max_price] || params[:min_price]) && params[:name]
    return 'max price must be >= 0' if params[:max_price].present? && params[:max_price].to_f <= 0
    return 'min price must be >= 0' if params[:min_price].present? && params[:min_price].to_f <= 0

    Item.find_all_by_name_or_price(params)
  end
end
