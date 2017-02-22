class Watchable < ApplicationRecord

  # TODO: Associations need to be made polymorphic if TV shows are added

  has_many :viewings, foreign_key: :viewed_id,
                      primary_key: :tmdb_id,
                      dependent: :destroy

  has_many :viewers, :through => :viewings,
                     :source => :viewer,
                     class_name: "User"

  def self.collect(service, watchables)
    watchables.each do |watchable|
      p "#{watchable["title"]}: #{watchable["url"]}"
    end
    puts service
  end

  def self.title_search(query, strict)
    return self.where("title ilike ?", query) if strict

    self.where("title ilike ?", "%#{query}%").order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def self.reindex
    watchables = all.order(:id)
    i = 1
    watchables.each do |watchable|
      watchable.id = i
      watchable.save
      i += 1
    end
    ActiveRecord::Base.connection.reset_pk_sequence!(:watchables)
  end

  def full_details
    # if url data api call has already been made, then return the obj
    # else make the api call to populate the data
    update_url_info unless requested

    self
  end

  private

    def update_url_info
      # TODO: ACTUALLY CALL populate_watchable_data once api is updated/available
      # MovieSyncer.populate_watchable_data(self.tmdb_id)

      self.requested = true
      self.save
    end
end
