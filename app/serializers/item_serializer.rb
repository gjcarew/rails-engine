class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :unit_price, :merchant_id

  def self.error(description)
    {
      "message": "your query could not be completed",
      "error": [
        "#{description}",
      ]
    }
  end
end
