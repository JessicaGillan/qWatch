class Watchable < ApplicationRecord

  # TODO: Associations need to be made polymorphic if TV shows are added

  has_many :activities, foreign_key: :tmdb_id,
                        primary_key: :tmdb_id,
                        dependent: :destroy

  has_many :users, :through => :activities

  # Public: collect data from stream sources data mining
  #
  # service - String: which streaming service is being mined
  # watchables - Hash: array of watchable titles and url strings
  #
  def self.collect(service, watchables)

    watchables.each do |watchable|
      p "#{watchable["title"]}: #{watchable["url"]}"
    end

    puts service
  end

  # Public: search for a movie/tv show by title
  #
  # query - String: string to match against
  # strict - boolean: Whether to only return exact matches
  #
  def self.title_search(query, strict = false)

    return self.where("title ilike ?", query) if strict
    self.where("title ilike ?", "%#{query}%").order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  # Public: reindex watchables table for contiguous indexing and optimized pagination
  #
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

  # Public: grab the full details for a watchable including streaming
  #
  def full_details

    # if url data api call has already been made, then return the obj
    # else make the api call to populate the data
    update_url_info unless requested
    self
  end

  private

    # Private: method used to grab the full information for a watchable
    #
    def update_url_info

      # TODO: ACTUALLY CALL populate_watchable_data once api is updated/available
      # MovieSyncer.populate_watchable_data(self.tmdb_id)
      self.requested = true
      self.save
    end
end
