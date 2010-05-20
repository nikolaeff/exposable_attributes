require 'test_helper'

# base
class User < ActiveRecord::Base
end

class User1 < User
  exposable_attributes :xml, :except => [:encrypted_password]
  exposable_attributes :json, :only => [:login]
end

class User2 < User
  exposable_attributes :id, :login
end

class ExposableAttributesTest < ActiveSupport::TestCase

  setup_db

  test "Four users should be created after db setup" do
    assert_equal 4, User.count
  end

  test "User1#to_json should not expose anything except login" do
    json = User1.first.to_json
    assert_match /login/,                 json

    assert_no_match /id/,                 json
    assert_no_match /salt/,               json
    assert_no_match /encrypted.password/, json
  end

  test "User1#to_xml should not expose encrypted_password" do
    xml = User1.first.to_xml

    assert_no_match /encrypted.password/, xml

    assert_match /id/,                    xml
    assert_match /login/,                 xml
    assert_match /salt/,                  xml
  end


  test "User2#to_xml and to_json should expose id and login only" do
    xml  = User2.first.to_xml
    json = User2.last.to_json

    for serialized in [xml, json] do
      assert_match /id/,                    serialized
      assert_match /login/,                 serialized
      assert_no_match /salt/,               serialized
      assert_no_match /encrypted.password/, serialized
    end
  end

  test "Ensure that User#to_xml and User#to_json are not affected" do
    xml  = User.first.to_xml
    json = User.last.to_json

    for serialized in [xml, json] do
      assert_match /id/,                 serialized
      assert_match /login/,              serialized
      assert_match /salt/,               serialized
      assert_match /encrypted.password/, serialized
    end
  end

end
