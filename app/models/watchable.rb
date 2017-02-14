class Watchable < ApplicationRecord
  def self.title_search(query)
    self.where("similarity(title, ?) > 0.3", query).order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def self.reindex
    watchables = all.order(:id)
    i = 1
    watchables.each do |watchable|
      watchable.id = i
      watchable.save
      i += 1
    end
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

  def full_details
  end
end
