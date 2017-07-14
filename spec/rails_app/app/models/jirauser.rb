class Jirauser < ApplicationRecord
  devise :jira_authenticable, authentication_keys: [ :username ]
end
