class DeviseCreateJirausers < ActiveRecord::Migration[5.1]
  def change
    create_table :jirausers do |t|
      ## jira_authenticatable
      t.string :username, null: false, default: ""

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false
    end

    add_index :jirausers, :username, unique: true
  end
end
