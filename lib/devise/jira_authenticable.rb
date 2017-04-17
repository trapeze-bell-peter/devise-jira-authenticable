require "devise/jira_authenticable/version"

require 'devise'

module Devise
  # The hostname or IP address of the radius server
  mattr_accessor :jira_site

  # The port for the radius server
  mattr_accessor :jira_context_path
  @@jira_context_path = ''

  # The secret for the JIRA server
  mattr_accessor :jira_additional_cookie

  # The timeout in seconds for radius requests
  mattr_accessor :jira_read_timeout
  @@radius_server_timeout = 120

  # The number of times to retry radius requests
  mattr_accessor :radius_server_retries
  @@radius_server_retries = 0
end

Devise.add_module(:jira_authenticable, :route => :session, :strategy => true,
                  :controller => :sessions, :model  => true)
