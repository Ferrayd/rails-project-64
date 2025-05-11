# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @post = posts(:one)
    sign_in @user

    # Очищаем лайки текущего пользователя для тестового поста
    @post.likes.where(user: @user).destroy_all
  end

  test 'should create like' do
    assert_difference('@post.likes.count', 1) do
      post post_likes_path(@post, locale: I18n.default_locale)
    end

    # Проверяем создание конкретной сущности
    created_like = @post.likes.find_by(user_id: @user.id)
    assert created_like, 'Лайк не был создан для текущего пользователя и поста'
    
    assert_redirected_to posts_url
    assert_equal I18n.t('likes.create.success'), flash[:notice]
  end

  test 'should destroy like' do
    like = @post.likes.create!(user: @user)
    
    assert_difference('@post.likes.count', -1) do
      delete post_like_path(@post, like, locale: I18n.default_locale)
    end

    # Проверяем что конкретный лайк был удален
    assert_nil Like.find_by(id: like.id), 'Лайк не был удален из базы данных'
    
    assert_redirected_to posts_url
    assert_equal I18n.t('likes.destroy.success'), flash[:notice]
  end
end
