class Watchable < ApplicationRecord
  has_many :viewings, :foreign_key => :viewed_id,
                      :class_name => "Viewing",
                      dependent: :destroy

  has_many :viewers, :through => :viewings,
                     :source => :viewer

  def self.title_search(query)
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
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
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
