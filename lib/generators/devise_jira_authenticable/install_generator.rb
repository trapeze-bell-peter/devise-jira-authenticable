module DeviseJiraAuthenticable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    desc <<-DESC.gsub(/ {6}/, '')
      Description:
        Adds jira_authenticable strategy to the devise initializer
        <JIRA SITE> - The URL address of the JIRA server
    DESC

    argument(:jira_site, :banner => '<URL>',
             :desc => 'The URL of the JIRA server')
    class_option(:timeout, :default => 120,
                 :desc => 'How long to wait for a response from the JIRA server')

    def install
      inject_into_file("config/initializers/devise.rb", default_devise_settings,
                       :before => /^\s*.*==> Scopes configuration/)
    end

    private

    def default_devise_settings
      <<-CONFIG.gsub(/ {6}/, '')
        # ==> Configuration for jira_authenticable
        # The jira_authenticable strategy can be used in place of the
        # database_authenticatable strategy or alongside it.  The default order of the
        # strategies is the reverse of how they were loaded.  You can control this
        # order by explicitly telling warden the order in which to apply the strategies.
        # See the Warden Configuration section for further details.
        #
        # Configure the URL of the JIRA server to use.
        config.jira_site = '#{jira_site}'
        # Configure the context path for the JIRA server.
        config.jira_context_path = #{options[:jira_context_path]}
      CONFIG
    end
  end
end