# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user
    PostLike.delete_all
  end

  test 'должен ставить лайк' do
    assert_difference('PostLike.count', 1) do
      post post_likes_url(@post)
    end
    assert_redirected_to post_path(@post)
  end

  test 'должен убирать лайк' do
    like = @post.post_likes.create!(user: @user)
    assert_difference('PostLike.count', -1) do
      delete post_like_url(post_id: @post.id, id: like.id)
    end
    assert_redirected_to post_path(@post)
  end
end
