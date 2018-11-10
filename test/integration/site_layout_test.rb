# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout_links' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path
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
  end
end
