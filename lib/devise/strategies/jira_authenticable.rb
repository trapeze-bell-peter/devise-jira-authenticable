require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    # Strategy for authenticating users with a JIRA server.  If authentication with
    # the JIRA server fails, allow warden to move on to the next strategy.  When
    # authentication succeeds and Devise indicates that the resource has been
    # successfully validated, invoke the +after_jira_authentication+ callback on the
    # resource and let warden know we were successful and not to continue with executing
    # further strategies.
    class JiraAuthenticable < Authenticatable
      # Invoked by warden to execute the strategy.
      def authenticate!
        auth_params = authentication_hash.merge(:password => password)
        resource = valid_password? &&
          mapping.to.find_for_jira_authentication(auth_params)
        return fail(:invalid) unless resource

        if validate(resource)
          resource.after_jira_authentication
          success!(resource)
        end
      end
    end
  end
end

Warden::Strategies.add(:jira_authenticable, Devise::Strategies::JiraAuthenticable)