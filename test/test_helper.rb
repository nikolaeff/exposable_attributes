require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'active_record/fixtures'

require File.join(File.dirname(__FILE__), '../rails/init')

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :users do |t|
      t.string :login
      t.string :encrypted_password
      t.string :salt
    end
  end

  4.times do |i|
    User.create!(:login => "anonymous-#{i}",
                 :encrypted_password => "password-#{i}",
                 :salt => "#{i ^ 65534}")
  end

end
