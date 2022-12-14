class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(@item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render status: bad_request
    end
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
    invoices = @item.invoices
    invoices.each(&:destroy_invoices)
    render json: @item.destroy
  end

  def find
    item = find_item_or_404(params)
    item = item.first if item.is_a?(ActiveRecord::Relation)
    return render json: ItemSerializer.error(item), status: :bad_request if item.is_a?(String)
    return render json: { "data": {} }, status: :bad_request if item.nil?

    render json: ItemSerializer.new(item)
  end

  def find_all
    items = find_item_or_404(params)
    return render json: ItemSerializer.error(items), status: :bad_request if items.is_a?(String)
    return render json: { "data": [] }, status: :bad_request if items.empty?

    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id )
  end

  def set_item
    render status: :bad_request unless Item.exists?(params[:id])

    @item = Item.find(params[:id])
  end

  def find_item_or_404(params)
    return "can't filter by name and price" if (params[:max_price] || params[:min_price]) && params[:name]
    return 'max price must be >= 0' if params[:max_price].present? && params[:max_price].to_f <= 0
    return 'max price must be present' if params[:max_price] && params[:max_price] == ''
    return 'min price must be >= 0' if params[:min_price].present? && params[:min_price].to_f <= 0
    return 'min price must be present' if params[:min_price] && params[:min_price] == ''
    return "search can't be empty" unless params[:min_price] || params[:max_price] || params[:name]
    return 'include a string in your search' if params[:name] && params[:name] == ''

    Item.find_by_name_or_price(params)
  end
end

