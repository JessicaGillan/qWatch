class Viewing < ApplicationRecord
  belongs_to :viewer, :class_name => "User"

  #  Use has_one since using custom primary_key on Watchable
  belongs_to :viewed, :foreign_key => :viewed_id,
                   :primary_key => :tmdb_id,
                   :class_name => "Watchable"

  # belongs_to :viewed, :foreign_key => :viewed_id,
  #                    :class_name => "Watchable"

  # Validate the uniqueness to avoid duplicate viewings.
  # This reflects the SQL uniqueness constraint
  validates :viewer_id, :uniqueness => { :scope => :viewed_id }

end
