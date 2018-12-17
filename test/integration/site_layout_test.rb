# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'layout_links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path
  end

  test 'route_links' do
    get root_path
    assert_select 'title', full_title

    get help_path
    assert_select 'title', full_title(page_title: 'Help')

    get about_path
    assert_select 'title', full_title(page_title: 'About')

    get contact_path
    assert_select 'title', full_title(page_title: 'Contact')

    get signup_path
    assert_select 'title', full_title(page_title: 'Sign up')

    get login_path
    assert_select 'title', full_title(page_title: 'Log in')
  end

  test 'layout links when logged in' do
    log_in_as(@user)

    get root_path

    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', logout_path
  end
end
