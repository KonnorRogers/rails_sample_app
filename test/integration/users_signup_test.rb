# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup info' do
    get signup_path

    assert_select 'form[action="/signup"]' # checks for proper signup url

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
end
