class Watchable < ApplicationRecord
  def self.title_search(query)
    self.where("similarity(title, ?) > 0.3", query).order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def full_details
  end
end
