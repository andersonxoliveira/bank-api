# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one :account
  before_validation :set_user_type

  enum user_type: {
    admin: 0,
    normal: 1,
    dba: 3
  }, _prefix: :user_type

  private

  def set_user_type
    self.user_type = :normal
  end
end
