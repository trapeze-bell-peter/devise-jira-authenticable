# Devise::Jira::Authenticable

This provides a mechanism to allow devise to authenticate using a JIRA instance.  It integrates with the jira-ruby.gem.  Even if you intend only to use a `jira-authenticable` strategy within Devise, I suggest starting by getting Devise going with the `database-authenticable` strategy.


The following instructions assume that you want to use the `jira-authenticable strategy` alongside another strategy such as `database-authenticatable`.

## Devise Preparation

As JIRA uses usernames rather than email addresses for login credentials I would also make the changes to your app to use a username within Devise before adding adding this Gem.  That way you can test that you have successfully implemented the user authentication before worrying about the JIRA interface.

The process is well documented [here](https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-with-something-other-than-their-email-address).  Personally, I found the simplest was to replace:

    config.authentication_keys = [:email]

with

    config.authentication_keys = [:username]

You will also need to add a simple migration to add the username to your users table (assuming that is where you store user login details):

```ruby
class AmendUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string, index: true
  end
end
```

You clearly need to then populate the username field.  The following example code creates usernames based on the current users email address:

```ruby
  # Static function to add usernames based on existing email addresses.
  def self.add_usernames
    User.transaction do
      User.all.each do |user|
        user.update!(username: /(\A[[:alpha:]]{2,}\.[a-z\-]{2,})@companyname\.com\z/.match(user.email)[1])
      end
    end
  end
```

Personally, I like to run something like the above script directly from the Rails console:

    # rails console
    Loading development environment (Rails 5.1.2)
    2.4.1 :001 > User.add_usernames

You also need to create the views as per the Devise instructions, and amend the views to use username rather than email.
    
## Installation

So your app now uses Devise for authentication, and you have switched to using usernames rather than emails.  Simply, add this line to your application's Gemfile:

```ruby
gem 'devise-jira-authenticable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install devise-jira-authenticatable

## Setting up the database

You then need to add `devise-jira-authenticable` as a strategy to your rails app.  Therefore, run:

    $ rails generate devise_jira_authenticable:install jira_site:https://jira-url/ 

This adds various configuration items to the `config/initializers/devise.rb` file.

## Changes to the Rails App

Amend the `jira_authenticable` configuration items in the Devise configuration file (`config/initializers/devise.rb`).  The key one, if you didn't already do so when running the generator is to make sure your URL is correctly defined.  The other one is the context path.  Many JIRA sites have a path to their JIRA system of the form: `company_url/dev_jira`.  The second part (`/dev_jira`) is set using the context path property in the config file.

Once correctly configured, simply add the `:jira_authenticable` strategy to the Devise user model and
you are good to go.  Assuming you want users to be authenticated against against JIRA first, then the devise line looks like:

```ruby
class User < ApplicationRecord

  devise :jira_authenticable, :database_authenticatable, :recoverable, :rememberable,
         :trackable, :validatable, :registerable
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/trapeze-bell-peter/devise-jira-authenticable]. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

