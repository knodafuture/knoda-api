class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :comments, :user_id
    add_index :comments, :prediction_id
    add_index :taggings, [:tagger_id, :tagger_type]
    add_index :taggings, [:tagging_id, :tagging_id]
    add_index :taggings, [:tag_id, :tagging_id]
    add_index :predictions, :user_id
    add_index :badges, :user_id
  end
end