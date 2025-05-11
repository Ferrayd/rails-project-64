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
    comment_attrs = { content: 'Test comment' }
    
    assert_difference('@post.comments.count', 1) do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: comment_attrs }
    end

    created_comment = @post.comments.find_by(
      comment_attrs.merge(user_id: @user.id)
    )
    
    assert created_comment, 'Комментарий не был создан с правильными атрибутами'
    assert_redirected_to @post
  end

  test 'should not create comment with empty body' do
    invalid_attrs = { content: '' }
    
    assert_no_difference('@post.comments.count') do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: invalid_attrs }
    end

    missing_comment = @post.comments.find_by(user_id: @user.id, content: '')
    assert_nil missing_comment, 'Комментарий с пустым содержанием был создан'
    assert_response :unprocessable_entity
  end

  test 'should create nested comment' do
    parent_comment = post_comments(:one)
    comment_attrs = { 
      content: 'Nested comment',
      parent_id: parent_comment.id 
    }
    
    assert_difference('@post.comments.count', 1) do
      post post_comments_path(@post, locale: I18n.default_locale),
           params: { post_comment: comment_attrs }
    end

    created_comment = @post.comments.find_by(
      comment_attrs.merge(user_id: @user.id)
    )
    
    assert created_comment, 'Вложенный комментарий не был создан'
    assert_equal parent_comment.id, created_comment.parent_id, 'Неверный родительский комментарий'
    assert_redirected_to @post
  end
end
