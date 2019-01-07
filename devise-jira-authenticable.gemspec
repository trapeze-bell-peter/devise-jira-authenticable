# coding: utf-8
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

  spec.add_dependency('devise', '~> 4.2')
  spec.add_dependency('jira-ruby', '~> 1.4.0')

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rubocop', '~> 0.62'
  spec.add_development_dependency 'rubocop-rspec'

  spec.add_development_dependency 'rails', '~> 5.1.3'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'puma', '~> 3.12'
  spec.add_development_dependency 'sass-rails', '~> 5.0'
  spec.add_development_dependency 'jquery-rails', '~> 4.3'

  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rspec-rails', '~> 3.8'
  spec.add_development_dependency 'capybara', '~> 3.12'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency "chromedriver-helper", "2.1"
  spec.add_development_dependency 'factory_bot_rails', '~> 4.11'
  spec.add_development_dependency 'webmock',  '~> 3.5'
  spec.add_development_dependency 'ammeter', '~> 1.1.4'
end
