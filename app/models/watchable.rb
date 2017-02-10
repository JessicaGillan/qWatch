class Watchable < ApplicationRecord
  has_one :poster, dependent: :destroy
  accepts_nested_attributes_for :poster
end
