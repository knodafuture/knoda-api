class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates_presence_of   :username
  validates_uniqueness_of :username
  #validates_length_of     :username, :minimum => 1, :maximum => 15
  validates_format_of     :username, :with => /\A[a-zA-Z0-9_]{1,15}\z/
end
