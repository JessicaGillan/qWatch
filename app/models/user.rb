class User < ApplicationRecord
  # Include devise modules
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, :omniauth_providers => [:facebook]

  has_many :viewings, :foreign_key => :viewer_id,
                      :class_name => "Viewing",
                      dependent: :destroy
  has_many :viewed_items, :through => :viewings,
                          :source => :viewed

  # When acting as the initiator of the friending
  has_many :initiated_friendings, :foreign_key => :friender_id,
                                  :class_name => "Friending",
                                  dependent: :destroy
  has_many :friended_users,       :through => :initiated_friendings,
                                  :source => :friend_recipient

  # When acting as the recipient of the friending
  has_many :received_friendings,  :foreign_key => :friend_id,
                                  :class_name => "Friending",
                                  dependent: :destroy
  has_many :users_friended_by,    :through => :received_friendings,
                                  :source => :friend_initiator

  def self.from_omniauth(auth)

    # TODO: Edit this to not create new if user with same email exists
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
      user.name = auth["info"]["name"]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def friends
    self.friended_users + self.users_friended_by
  end

  def add_fb_friends(fb_user_info)
    friend_ids = self.friends.pluck(:id)

    fb_user_info.each do |index, friend|

      user_friend = User.find_by(provider: "facebook", uid: friend["id"].to_i)

      if user_friend && !(friend_ids.include? user_friend.id)
        self.friended_users << user_friend
      end
    end
  end

  def friends_viewings
    Viewing
    .joins("JOIN users ON viewings.viewer_id = users.id")
    .joins("JOIN watchables ON viewings.viewed_id = watchables.id")
    .where(viewer_id: self.friends.pluck(:id))
    .order('viewings.created_at DESC')
    .select('viewings.created_at AS created_at',
            'users.name AS friend',
            'watchables.title AS title',
            'watchables.id AS viewed_id')
  end
end
