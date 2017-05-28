

require 'devise'

require 'devise/jira_authenticable/version'
require 'devise/models/jira_authenticable'
require 'devise/strategies/jira_authenticable'

module Devise
  # The URL of the JIRA server.
  mattr_accessor :jira_site

  # The context path for the JIRA server ()
  mattr_accessor :jira_context_path
  @@jira_context_path = ''

  # The secret for the JIRA server
  # The timeout in seconds for radius requests
  mattr_accessor :jira_read_timeout
  @@jira_read_timeout = 120
end

Devise.add_module(:jira_authenticable, route: :session, strategy: true, controller: :sessions, model: true)
