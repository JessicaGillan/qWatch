class Viewing < ApplicationRecord
  belongs_to :viewer, :foreign_key => :viewer_id,
                      :class_name => "User"

  belongs_to :viewed, :foreign_key => :viewed_id,
                      :class_name => "Watchable"

  # Validate the uniqueness to avoid duplicate viewings.  
  # This reflects the SQL uniqueness constraint
  validates :viewer_id, :uniqueness => { :scope => :viewed_id }

end
