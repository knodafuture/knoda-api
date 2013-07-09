class Prediction < ActiveRecord::Base

acts_as_taggable

belongs_to :user

validates :title, presence: true
validates :text, presence: true
validates :expires_at, presence: true
validates :tag_list, presence: true

default_scope order("created_at")
end
