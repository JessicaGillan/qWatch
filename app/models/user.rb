# Public: DB Model for users table
#
class User < ApplicationRecord


  ##### DEVISE ASSOCIATIONS #####
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :trackable,
          :omniauthable, :omniauth_providers => [:facebook, :twitter, :google]

  ##### DB ASSOCIATIONS #####

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy

  has_many :viewings, foreign_key: :viewer_id,
                      dependent: :destroy

  has_many :viewed_items, through: :viewings,
                          source: :viewed,
                          class_name: 'Watchable'

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

  # Avoid n+1 queries, grab all authenticables
  default_scope {
    includes :authentications
  }

  # Public: Create a new user from OAuth Login
  #
  # auth - Hash: Authentication data returned from omniAuth
  #
  def self.create_from_omniauth(auth)
    attributes = {
      email: auth['info']['email'],
      name: auth["info"]["name"],
      password: Devise.friendly_token
    }

    create(attributes)
  end

  # Public: Overwrite default to_json to User Model, so that devise includes OAuth Joins
  #
  # arg - any: field from devise, unused
  #
  def to_json(arg)
    self.as_json(include: [:authentications]).to_json
  end

  # Public: All of a user's friends
  #
  def friends
    self.friended_users + self.users_friended_by
  end

  # Public: import user's friends from facebook
  #
  # fb_user_info - Hash: OAuth Facebook data
  #
  def add_fb_friends(fb_user_info)
    friend_ids = self.friends.pluck(:id)

    fb_user_info.each do |index, friend|

      user_friend = UserAuthentication.find_by(provider: "facebook", uid: friend["id"].to_i).user

      if user_friend && !(friend_ids.include? user_friend.id)
        self.friended_users << user_friend
      end
    end
  end

  # Public: View the recently viewed item for all of a user's friends
  #
  def friends_viewings
    Viewing
    .joins("JOIN users ON viewings.viewer_id = users.id")
    .joins("JOIN watchables ON viewings.viewed_id = watchables.tmdb_id")
    .where(viewer_id: self.friends.pluck(:id))
    .order('viewings.created_at DESC')
    .select('viewings.created_at AS viewed_at',
            'users.name AS friend',
            'watchables.title AS title',
            'watchables.tmdb_id AS tmdb_id')
  end

  # Public: View the recently viewed item for a user
  #
  def viewed_items_slim
    Viewing
    .joins("JOIN watchables ON viewings.viewed_id = watchables.tmdb_id")
    .where(viewer_id: self.id)
    .order('viewings.created_at DESC')
    .select('viewings.created_at AS viewed_at',
            'watchables.title AS title',
            'watchables.tmdb_id AS tmdb_id',
            'watchables.tmdb_type AS tmdb_type')
  end
end
