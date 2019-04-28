# frozen_string_literal: true

require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper # gives access to full title method

  def setup
    @user = users(:michael)
  end

  test 'profile display' do
    get user_path(@user)

    assert_template 'users/show'
    assert_select 'title', full_title(page_title: @user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar' # checks for a nested img tag inside h1
    assert_match(@user.microposts.count.to_s, response.body)
    assert_select 'div.pagination', count: 1

    # response returns the full html source of the page
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match(micropost.content, response.body)
    end

    # following / follower tests
    assert_template 'shared/_stats'

    assert_select 'a[href=?]', following_user_path(@user)
    assert_select 'a[href=?]', followers_user_path(@user)

    assert_match @user.followers.count.to_s, response.body
    assert_match @user.following.count.to_s, response.body
  end
end
