class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.error(description)
    {
      "message": "your query could not be completed",
      "error": [
        "#{description}",
      ]
    }
  end
end
