class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.references :user, :null => false
      t.integer :group_id, :null => true
      t.string :code, :null => true      
    end
  end
end
