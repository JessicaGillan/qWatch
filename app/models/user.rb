class User < ApplicationRecord

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  # Include devise modules
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :trackable,
          :omniauthable, :omniauth_providers => [:facebook, :twitter, :google]

  default_scope {
    includes :authentications
  }

  def self.create_from_omniauth(auth)
    attributes = {
      email: auth['info']['email'],
      name: auth["info"]["name"],
      password: Devise.friendly_token
    }

    create(attributes)
  end

  def to_json(arg)
    self.as_json(include: [:authentications]).to_json
  end


end
