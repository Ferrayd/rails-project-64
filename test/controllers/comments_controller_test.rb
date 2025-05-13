# frozen_string_literal: true

# test/controllers/comments_controller_test.rb
require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user
  end

  test 'should create comment' do
    comment_attrs = { content: 'Test comment' }

    assert_difference('@post.comments.count', 1) do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: comment_attrs }
    end

    created_comment = @post.comments.find_by(
      content: comment_attrs[:content],
      user_id: @user.id,
      ancestry: nil
    )

    assert created_comment, 'Comment was not created with correct attributes'
    assert_equal @user, created_comment.user, 'Comment does not belong to the correct user'
    assert_equal @post, created_comment.post, 'Comment does not belong to the correct post'
    assert_redirected_to @post
    assert_equal I18n.t('comments.create.success'), flash[:notice], 'Success message not set'
  end

  test 'should not create comment with empty content' do
    invalid_attrs = { content: '' }

    assert_no_difference('@post.comments.count') do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: invalid_attrs }
    end

    missing_comment = @post.comments.find_by(user_id: @user.id, content: '')
    assert_nil missing_comment, 'Comment with empty content was created'
    assert_response :unprocessable_entity
    assert_includes flash[:alert], I18n.t('comments.create.failure'), 'Failure message not set'
  end

  test 'should create nested comment' do
    parent_comment = post_comments(:one)
    comment_attrs = { content: 'Nested comment', parent_id: parent_comment.id }

    assert_difference('@post.comments.count', 1) do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: comment_attrs }
    end

    created_comment = @post.comments.find_by(
      content: comment_attrs[:content],
      user_id: @user.id
    )

    assert created_comment, 'Nested comment was not created'
    assert_equal parent_comment, created_comment.parent, 'Incorrect parent comment'
    assert_equal @user, created_comment.user, 'Nested comment does not belong to the correct user'
    assert_equal @post, created_comment.post, 'Nested comment does not belong to the correct post'
    assert_redirected_to @post
    assert_equal I18n.t('comments.create.success'), flash[:notice], 'Success message not set'
  end
end
