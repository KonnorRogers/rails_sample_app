# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup info' do
    get signup_path

    assert_select 'form[action="/users"]' # checks for proper signup url

    # tests prior to and after the block
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          name: '',
          email: 'user@invalid',
          password: 'foo',
          password_confirmation: 'bar'
        }
      }
    end

    assert_template 'users/new' # tests that it renders users/new
    assert_select 'div.field_with_errors' # checks that it gets wrapped
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          name: 'Example User',
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
