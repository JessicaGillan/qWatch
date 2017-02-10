class Watchable < ApplicationRecord
  has_one :poster, inverse_of: :watchable, dependent: :destroy
  accepts_nested_attributes_for :poster


end
