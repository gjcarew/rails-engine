class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id

  def self.error(description)
    {
      "message": description.to_s,
      "error": {}
    }
  end
end
