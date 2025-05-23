# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @post_for_create = posts(:two)
    @post_for_destroy = posts(:one)
    @like = post_likes(:one)
    sign_in @user
  end

  test 'should create like' do
    assert_difference('@post_for_create.likes.count', 1) do
      post post_likes_path(@post_for_create, locale: I18n.default_locale)
    end

    created_like = @post_for_create.likes.find_by(user_id: @user.id)
    assert created_like, 'Like was not created for the current user and post'

    assert_redirected_to posts_url
    assert_equal I18n.t('likes.create.success'), flash[:notice]
  end

  test 'should destroy like' do
    assert_not_nil @like, 'Expected like to exist before destroy'

    assert_difference('@post_for_destroy.likes.count', -1) do
      delete post_like_path(@post_for_destroy, @like, locale: I18n.default_locale)
    end

    assert_nil PostLike.find_by(id: @like.id), 'Like was not deleted from the database'

    assert_redirected_to posts_url
    assert_equal I18n.t('likes.destroy.success'), flash[:notice]
  end
end
