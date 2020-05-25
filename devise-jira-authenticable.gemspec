lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/jira_authenticable/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise-jira-authenticable'
  spec.version       = Devise::JiraAuthenticable::VERSION
  spec.authors       = ['trapeze.bell.peter']
  spec.email         = ['peter.bell@trapezegroup.com']

  spec.summary       = 'Provide Devise authentication using a JIRA instance.'
  spec.description   = 'Interacts with the ruby-jira gem to provide authentication of a login against a JIRA system.'
  spec.homepage      = 'https://github.com/trapeze-bell-peter/devise-jira-authenticable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency('devise', '~> 4.7')
  spec.add_dependency('jira-ruby', '~> 2.0.0')
  spec.add_dependency('rails', '~> 6.0')

  spec.add_development_dependency 'bundler', '2.1.4'
  spec.add_development_dependency 'puma', '~> 4.3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 0.81'
  spec.add_development_dependency 'rubocop-rspec'

  spec.add_development_dependency 'rails', '~> 6.0'

  spec.add_development_dependency 'jquery-rails', '~> 4.3'
  spec.add_development_dependency 'sass-rails', '~> 5.0'
  spec.add_development_dependency 'sqlite3', '~> 1.4'

  spec.add_development_dependency 'ammeter', '~> 1.1.4'
  spec.add_development_dependency 'capybara', '~> 3.12'
  spec.add_development_dependency 'chromedriver-helper', '2.1'
  spec.add_development_dependency 'factory_bot_rails', '~> 4.11'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rspec-html-matchers'
  spec.add_development_dependency 'rspec-rails', '~> 3.9'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'webmock', '~> 3.5'
end
