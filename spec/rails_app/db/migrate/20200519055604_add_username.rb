class AddUsername < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, nil: false, index: true
  end
end
