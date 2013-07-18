class AddClosedAsToPredictions < ActiveRecord::Migration
  def change
    add_column :predictions, :closed_as, :date
  end
end
