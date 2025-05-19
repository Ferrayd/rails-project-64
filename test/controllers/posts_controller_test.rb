# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @category = categories(:two)
    @post = posts(:one)
    sign_in @user
  end

  test 'should create post' do
    post_attrs = {
      title: 'Test',
      body: 'Test body',
      category_id: @category.id
    }

    assert_difference('Post.count', 1) do
      post posts_url, params: { post: post_attrs }
    end

    created_post = Post.find_by(post_attrs.merge(creator_id: @user.id))
    assert created_post, 'Post was not created with correct attributes'

    assert_redirected_to posts_url
  end

  test 'should not create post with invalid data' do
    invalid_attrs = { title: '', body: '', category_id: @category.id }

    assert_no_difference('Post.count') do
      post posts_url, params: { post: invalid_attrs }
    end
    assert_response :unprocessable_entity
  end

  test 'should display post' do
    get post_url(@post, locale: 'en')
    assert_response :success
    assert_includes response.body, @post.title
    assert_includes response.body, @post.body
  end

  test 'should redirect to login page if user is not authenticated when creating post' do
    sign_out @user
    post_attrs = { title: 'Test', body: 'Test body', category_id: @category.id }

    assert_no_difference('Post.count') do
      post posts_url, params: { post: post_attrs }
    end

    assert_nil Post.find_by(post_attrs), 'Post was created without authentication'
    assert_redirected_to new_user_session_path
  end

  test 'should get index' do
    sign_out @user
    get posts_url(locale: I18n.default_locale)
    assert_response :success
    assert_includes response.body, @post.title
  end

  test 'should get new' do
    get new_post_url(locale: I18n.default_locale)
    assert_response :success
    assert_select "form[action='#{posts_path}']"
  end
end
