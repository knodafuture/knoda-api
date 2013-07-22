class User < ActiveRecord::Base
  # Adds `can_create?(resource)`, etc
  include Authority::UserAbilities
  
  after_create :registration_badges
  
  has_many :predictions, :dependent => :destroy
  has_many :challenges, :dependent => :destroy
  has_many :badges, :dependent => :destroy
  has_many :voted_predictions, through: :challenges, class_name: "Prediction", source: 'prediction'
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable,
         :authentication_keys => [:login]
         
  validates_presence_of   :username
  validates_uniqueness_of :username
  validates_format_of     :username, :with => /\A[a-zA-Z0-9_]{1,15}\z/
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  attr_accessor :login
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
  
  def registration_badges
    case self.id
      when 1..500
        # Gold founding user badge
        self.badges.create(:name => 'gold_founding')
      when 501..5000
        # Silver founding user badge
        self.badges.create(:name => 'silver_founding')
    end
  end
  
  def prediction_create_badges
    case self.predictions.count
      when 1
        # first prediction badge
        self.badges.create(:name => '1_prediction')
      when 10
        # 10 predictions made 
        self.badges.create(:name => '10_predictions')
    end
  end
end