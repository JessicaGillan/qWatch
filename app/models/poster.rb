class Poster < ApplicationRecord
  belongs_to :watchable, inverse_of: :poster
end
