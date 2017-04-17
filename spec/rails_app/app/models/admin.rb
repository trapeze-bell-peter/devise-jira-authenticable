class Admin < ActiveRecord::Base
  devise :database_authenticatable, :jira_authenticable

  attr_accessor :login

  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    conditions[:email] = login
    super
  end
end
