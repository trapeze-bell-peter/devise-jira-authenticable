require 'rails_helper'

RSpec.shared_context 'mock jira http calls', :shared_context => :metadata do
  require 'webmock/rspec'

  let(:example_user) { FactoryBot.build :jirauser }

  let(:session_cookie) { '6E3487971234567896704A9EB4AE501F' }
  let(:session_body) do
    {
      'session': { 'name' => "JSESSIONID", 'value' => session_cookie },
      'loginInfo': { 'failedLoginCount' => 1, 'loginCount' => 2,
                     'lastFailedLoginTime' => (DateTime.now - 2).iso8601,
                     'previousLoginTime' => (DateTime.now - 5).iso8601 }
    }
  end

  before(:each) do
    # General case of API call with no authentication, or wrong authentication
    stub_request(:post, 'https://remotejira.com/jira/rest/auth/1/session')
      .to_return(status: 401, headers: {})

    # Now special case of API with correct authentication.  This gets checked first by RSpec.
    stub_request(:post, 'https://remotejira.com/jira/rest/auth/1/session')
      .with(body: "{\"username\":\"#{example_user.username}\",\"password\":\"password\"}")
      .to_return(status: 200, body: session_body.to_json,
                 headers: { 'Set-Cookie': "JSESSIONID=#{session_cookie}; Path=/; HttpOnly" })

    stub_request(:get, 'https://remotejira.com/jira/rest/api/2/project')
      .with(headers: { cookie: "JSESSIONID=#{session_cookie}" })
      .to_return(status: 200, body: '[]', headers: {})
  end
end
