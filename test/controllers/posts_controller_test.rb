# frozen_string_literal: true

require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @category = categories(:one)
    @post = posts(:one)
    sign_in @user
  end

  test 'должен создавать пост' do
    post_attrs = {
      title: 'Тест',
      body: 'Тестовое тело',
      category_id: @category.id
    }

    assert_difference('Post.count', 1) do
      post posts_url, params: { post: post_attrs }
    end

    created_post = Post.find_by(post_attrs.merge(creator_id: @user.id))
    assert created_post, 'Пост не был создан с правильными атрибутами'
    
    assert_redirected_to posts_url
    assert_equal post_attrs[:title], created_post.title
    assert_equal post_attrs[:body], created_post.body
    assert_equal @category.id, created_post.category_id
    assert_equal @user, created_post.creator
  end

  test 'не должен создавать пост с невалидными данными' do
    invalid_attrs = { title: '', body: '', category_id: @category.id }
    
    assert_no_difference('Post.count') do
      post posts_url, params: { post: invalid_attrs }
    end

    missing_post = Post.find_by(
      title: invalid_attrs[:title],
      body: invalid_attrs[:body],
      creator_id: @user.id
    )
    assert_nil missing_post, 'Пост с невалидными данными был создан'
    assert_response :unprocessable_entity
  end

  test 'должен отображать пост' do
    get post_url(@post, locale: 'ru')
    assert_response :success
    assert_includes response.body, @post.title
    assert_includes response.body, @post.body
  end

  test 'должен редактировать пост' do
    get edit_post_url(@post, locale: 'ru')
    assert_response :success
    assert_includes response.body, @post.title
  end

  test 'должен обновлять пост' do
    update_attrs = {
      title: 'Обновленный тест',
      body: 'Обновленное тело',
      category_id: @category.id
    }

    patch post_url(@post, locale: 'ru'), params: { post: update_attrs }
    
    assert_redirected_to posts_url
    @post.reload
    
    assert_equal update_attrs[:title], @post.title
    assert_equal update_attrs[:body], @post.body
    assert_equal update_attrs[:category_id], @post.category_id
    assert_equal @user, @post.creator
  end

  test 'должен удалять пост' do
    assert_difference('Post.count', -1) do
      delete post_url(@post, locale: 'ru')
    end

    assert_nil Post.find_by(id: @post.id), 'Пост не был удален из базы'
    assert_redirected_to posts_url
  end

  test 'должен перенаправлять на страницу входа, если пользователь не авторизован при создании поста' do
    sign_out @user
    post_attrs = { title: 'Тест', body: 'Тестовое тело', category_id: @category.id }

    assert_no_difference('Post.count') do
      post posts_url, params: { post: post_attrs }
    end

    assert_nil Post.find_by(post_attrs), 'Пост был создан без авторизации'
    assert_redirected_to new_user_session_path
  end

  test 'должен корректно обрабатывать попытку обновления поста с невалидными данными' do
    original_attributes = @post.attributes.slice('title', 'body', 'category_id')
    
    patch post_url(@post, locale: 'ru'), params: { post: { title: '', body: '' } }
    
    assert_response :unprocessable_entity
    @post.reload
    
    assert_equal original_attributes['title'], @post.title
    assert_equal original_attributes['body'], @post.body
    assert_equal original_attributes['category_id'], @post.category_id
  end
end
