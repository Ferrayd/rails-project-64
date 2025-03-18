# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user

    @post.post_likes.where(user: @user).destroy_all
  end

  test 'should create like' do
    assert_difference('@post.post_likes.count', 1) do
      post post_likes_path(@post, locale: I18n.default_locale)
    end

    assert_redirected_to posts_url
    assert_equal I18n.t('likes.create.success'), flash[:notice]
  end

  test 'should destroy like' do
    like = @post.post_likes.create!(user: @user)

    assert_difference('@post.post_likes.count', -1) do
      delete post_like_path(@post, like, locale: I18n.default_locale)
    end

    assert_redirected_to posts_url
    assert_equal I18n.t('likes.destroy.success'), flash[:notice]
  end
end
