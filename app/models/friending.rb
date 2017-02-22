class Friending < ApplicationRecord
  # The Initiator side
  belongs_to :friend_initiator, :foreign_key => :friender_id,
                                :class_name => "User"

  # The Recipient side
  belongs_to :friend_recipient, :foreign_key => :friend_id,
                                :class_name => "User"
  # can't add friend twice
  validates :friend_id, :uniqueness => { :scope => :friender_id }

end
