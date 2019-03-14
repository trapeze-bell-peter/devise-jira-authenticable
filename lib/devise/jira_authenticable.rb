require 'devise'

require 'devise/jira_authenticable/version'
require 'devise/models/jira_authenticable'
require 'devise/strategies/jira_authenticable'

module Devise
  # authentication_keys = [ :username ]

  # The URL of the JIRA server.
  mattr_accessor :jira_site

  # The context path for the JIRA server ()
  mattr_accessor :jira_context_path
  @@jira_context_path = ''

  # The timeout in seconds for JIRA requests
  mattr_accessor :jira_read_timeout
  @@jira_read_timeout = 120

  # Option to handle radius timeout as authentication failure
  mattr_accessor :handle_jira_timeout_as_failure
  @@handle_jira_timeout_as_failure = false
end

Devise.add_module(:jira_authenticable, route: :session, strategy: true, controller: :sessions, model: true)
