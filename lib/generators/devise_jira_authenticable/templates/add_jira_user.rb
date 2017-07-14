class JiraAuthenticableCreateJiraUser < ActiveRecord::Migration<%= migration_version %>
  create_table :jira_users do |t|
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

  add_index :jira_users, :username, unique: true
end