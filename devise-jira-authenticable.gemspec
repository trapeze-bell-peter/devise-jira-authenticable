# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/jira_authenticable/version'

Gem::Specification.new do |spec|
  spec.name          = 'devise-jira-authenticable'
  spec.version       = Devise::Jira::Authenticable::VERSION
  spec.authors       = ['trapeze.bell.peter']
  spec.email         = ['peter.bell@trapezegroup.com']

  spec.summary       = 'Provide Devise authentication using a JIRA instance.'
  spec.description   = 'Interacts with the ruby-jira gem to provide authentication of a login against a JIRA system.'
  spec.homepage      = 'https://github.com/trapeze-bell-peter/devise-jira-authenticable'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency('devise', '~> 4.2')
  spec.add_dependency('jira-ruby', '~> 1.2.0')

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 12.0'

  spec.add_development_dependency 'rails', '~> 5.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'jquery-rails', '~> 4.3'

  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rspec-rails', '~> 3.6'
  spec.add_development_dependency 'capybara', '~> 2.13'
  spec.add_development_dependency 'factory_girl_rails', '~> 4.8'
end
