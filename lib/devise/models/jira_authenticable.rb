require 'jira-ruby'
require 'devise/strategies/jira_authenticable'

module Devise
  module Models
    # The JiraAuthenticable module is responsible for validating a user's credentials
    # against the configured JIRA server.  When authentication is successful, the
    # attributes returned by the JIRA server are made available via the
    # +jira_attributes+ accessor in the user model.
    #
    # The JiraAuthenticable module works by using the configured
    # +radius_uid_generator+ to generate a UID based on the username and the radius server
    # hostname or IP address.  This UID is used to see if an existing record representing
    # the user already exists.  If it does, radius authentication proceeds through that
    # user record.  Otherwise, a new user record is built and authentication proceeds.
    # If authentication is successful, the +after_radius_authentication+ callback is
    # invoked, the default implementation of which simply saves the user record with
    # validations disabled.
    #
    # The radius username is extracted from the parameters hash by using the first
    # configured value in the +Devise.authentication_keys+ array.  If the authentication
    # key is in the list of case insensitive keys, the username will be converted to
    # lowercase prior to authentication.
    #
    # == Options
    #
    # JiraAuthenticable adds the following options to devise_for:
    # * +jira_site+: The URL for the JIRA server.
    # * +jira_context_path+: the context path for JIRA.
    # * +jira_read_timeout+: The time we wait for a response from JIRA.
    #
    # == Callbacks
    #
    # The +after_jira_authentication+ callback is invoked on the user record when
    # JIRA authentication succeeds for that user but prior to Devise checking if the
    # user is active for authentication.  Its default implementation simply saves the
    # user record with validations disabled.  This method should be overriden if further
    # actions should be taken to make the user valid or active for authentication.  If
    # you override it, be sure to either call super to save the record or to save the
    # record yourself.
    module JiraAuthenticable
      extend ActiveSupport::Concern

      included do
        attr_accessor :jira_client
      end

      # Use the currently configured JIRA server to attempt to authenticate the
      # supplied username and password.  If authentication succeeds, make the JIRA
      # attributes returned by the server available via the radius_attributes accessor.
      # Returns true if authentication was successful and false otherwise.
      #
      # Parameters::
      # * +username+: The username to send to the radius server
      # * +password+: The password to send to the radius server
      def valid_jira_password?(username, password)
        self.jira_client = JIRA::Client.new(
          username: username,
          password: password,
          site: self.class.jira_site,
          context_path: self.class.jira_context_path,
          auth_type: :cookie,
          use_cookies: true,
          read_timeout: self.class.jira_read_timeout
        )
        self.jira_client.authenticated?
      end

      # Callback invoked by the JiraAuthenticable strategy after authentication
      # with the JIRA server has succeeded and devise has indicated the model is valid.
      # This callback is invoked prior to devise checking if the model is active for
      # authentication.
      def after_jira_authentication
        self.save(validate: false)
      end

      module ClassMethods
        Devise::Models.config(self, :jira_site, :jira_context_path, :jira_read_timeout)

        # Invoked by the JiraAuthenticatable strategy to perform the authentication
        # against the JIRA server.  The username is extracted from the authentication hash.
        # We then search for an existing resource using the username.  If no resource
        # is found, a new resource is built (not created).  If authentication is
        # successful the callback is responsible for saving the resource.  Returns the
        # resource if authentication succeeds and nil if it does not.
        def find_for_jira_authentication(authentication_hash)
          username, password = jira_credentials(authentication_hash)

          resource = find_for_authentication({ username: username  }) || new(username: username)

          resource.valid_jira_password?(username, password) ? resource : nil
        end

        # Extract the username and password from the supplied authentication hash.  The
        # username is extracted using the first value from +Devise.authentication_keys+.
        # The username is converted to lowercase if the authentication key is in the list
        # of case insensitive keys configured for Devise.
        def jira_credentials(authentication_hash)
          key = self.authentication_keys.first
          value = authentication_hash[key]
          value.downcase! if (self.case_insensitive_keys || []).include?(key)

          [value, authentication_hash[:password]]
        end
      end
    end
  end
end
