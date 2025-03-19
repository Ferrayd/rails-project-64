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
    assert_difference('Post.count', 1) do
      post posts_url,
           params: { post: { title: 'Тест', body: 'Тестовое тело', category_id: @category.id } }
    end
    assert_redirected_to posts_url
    assert_equal 'Тест', Post.last.title
    assert_equal 'Тестовое тело', Post.last.body
    assert_equal @user, Post.last.creator
  end

  test 'не должен создавать пост с невалидными данными' do
    assert_no_difference('Post.count') do
      post posts_url, params: { post: { title: '', body: '', category_id: @category.id } }
    end
    assert_response :unprocessable_entity
  end

  test 'должен отображать пост' do
    get post_url(@post, locale: 'ru')
    assert_response :success
    assert_includes response.body, @post.title # Проверяем, что заголовок поста есть в теле ответа
  end

  test 'должен редактировать пост' do
    get edit_post_url(@post, locale: 'ru')
    assert_response :success
  end

  test 'должен обновлять пост' do
    patch post_url(@post, locale: 'ru'),
          params: { post: { title: 'Обновленный тест', body: 'Обновленное тело', category_id: @category.id } }
    assert_redirected_to posts_url
    @post.reload
    assert_equal 'Обновленный тест', @post.title
    assert_equal 'Обновленное тело', @post.body
  end

  test 'должен удалять пост' do
    assert_difference('Post.count', -1) do
      delete post_url(@post, locale: 'ru')
    end
    assert_redirected_to posts_url
  end

  test 'должен перенаправлять на страницу входа, если пользователь не авторизован при создании поста' do
    sign_out @user
    assert_no_difference('Post.count') do
      post posts_url,
           params: { post: { title: 'Тест', body: 'Тестовое тело', category_id: @category.id } }
    end
    assert_redirected_to new_user_session_path
  end

  test 'должен перенаправлять на страницу входа, если пользователь не авторизован при редактировании поста' do
    sign_out @user
    get edit_post_url(@post, locale: 'ru')
    assert_redirected_to new_user_session_path
  end

  test 'должен перенаправлять на страницу входа, если пользователь не авторизован при обновлении поста' do
    sign_out @user
    patch post_url(@post, locale: 'ru'),
          params: { post: { title: 'Обновленный тест', body: 'Обновленное тело', category_id: @category.id } }
    assert_redirected_to new_user_session_path
  end

  test 'должен перенаправлять на страницу входа, если пользователь не авторизован при удалении поста' do
    sign_out @user
    assert_no_difference('Post.count') do
      delete post_url(@post, locale: 'ru')
    end
    assert_redirected_to new_user_session_path
  end

  test 'должен отображать индекс постов' do
    get posts_url
    assert_response :success
    assert_includes response.body, @post.title # Проверяем, что заголовок поста есть в теле ответа
  end

  test 'должен корректно обрабатывать попытку обновления поста с невалидными данными' do
    patch post_url(@post, locale: 'ru'), params: { post: { title: '', body: '' } }
    assert_response :unprocessable_entity
  end
end
