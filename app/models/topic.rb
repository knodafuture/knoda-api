class Topic < ActiveRecord::Base
  scope :find_active, -> { where('hidden is false').order('name') }
  scope :find_active_by_pattern, ->(pattern) { where('hidden is false and name like ?', '%'+pattern+'%').order('name') }
end
