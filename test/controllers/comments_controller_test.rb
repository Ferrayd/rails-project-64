# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user
  end

  test 'should create comment' do
    assert_difference('@post.comments.count', 1) do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: { content: 'Test comment' } }
    end

    assert_redirected_to @post
  end

  test 'should not create comment with empty body' do
    assert_no_difference('@post.comments.count') do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: { content: '' } }
    end

    assert_response :unprocessable_entity
  end

  test 'should create nested comment' do
    parent_comment = post_comments(:one)

    assert_difference('@post.comments.count', 1) do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: { content: 'Nested comment', parent_id: parent_comment.id } }
    end

    assert_redirected_to @post
  end
end
