# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user
  end

  test 'должен создать комментарий' do
    assert_difference('PostComment.count') do
      post post_comments_url(@post), params: { post_comment: { content: 'Test comment' } }
    end
    assert_redirected_to post_path(@post)
  end
end
