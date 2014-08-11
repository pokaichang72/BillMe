class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.from_facebook(auth)
    user = where({:fbid => auth.uid}).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
    user.name = auth.info.name
    user.email = auth.info.email
    user.fbtoken = auth.credentials.token
    user.save
    return user
  end
end
