class Activity < ApplicationRecord
  belongs_to :user

  #  Use has_one since using custom primary_key on Watchable
  belongs_to :watchable, :foreign_key => :tmdb_id,
                         :primary_key => :tmdb_id,
                         :class_name => "Watchable"

  # Validate the uniqueness to avoid duplicate viewings.
  # This reflects the SQL uniqueness constraint
  validates :user_id, :uniqueness => { :scope => :tmdb_id }

end
