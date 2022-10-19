class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_one(search_params)
    where("name ILIKE ?", "%#{search_params}%").first
  end

  def self.find_all(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
