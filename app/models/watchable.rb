class Watchable < ApplicationRecord
  def self.title_search(query)
    self.where("similarity(title, ?) > 0.3", query).order("similarity(title, #{ActiveRecord::Base.connection.quote(query)}) DESC")
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
