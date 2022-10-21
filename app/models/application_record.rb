class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_by_name(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
