class User < ApplicationRecord
  # Include devise modules
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, :omniauth_providers => [:facebook]

  has_many :viewings, :foreign_key => :viewer_id,
                      :class_name => "Viewing"
  has_many :viewed_items, :through => :viewings,
                          :source => :viewed


  def self.from_omniauth(auth)

    # TODO: Edit this to not create new if user with same email exists
    where(provider: auth["provider"], uid: auth["uid"]).first_or_create do |user|
      user.email = auth["info"]["email"]
      user.password = Devise.friendly_token[0,20]
      user.name = auth["info"]["name"]
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
