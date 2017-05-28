
# The jira-ruby gem uses its own class HttpClient internally to connect to JIRA.  Here we stub the class to provide
# test versions of the methods.
module MockedHttpClient
  class HttpClient
    def initialize(options)
      @user = FactoryGirl.build :user
      @options = options
    end

    def make_cookie_auth_request
      @options[:user]==@user.username && @options[:password]==@user.password ? @options : nil
    end
  end

  # Setup mocks.
  def setup_http_client_mocks
    allow(JIRA::HttpClient).to receive(:new) do |options|
      HttpClient.new(options)
    end
  end
end
