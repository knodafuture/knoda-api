class HistorySerializer < ActiveModel::Serializer
  attributes :id, :agree, :created_at, :is_own, :points_details
  has_one :prediction
  self.root = false
end

# can remove seen, is_finished, bs, is_right