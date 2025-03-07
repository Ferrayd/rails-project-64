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
           params: { post: { title: 'Тест', body: 'Тестовое тело', category_id: @category.id, creator_id: @user.id } }
    end
    assert_redirected_to post_path(Post.last)
    assert_equal 'Тест', Post.last.title
    assert_equal 'Тестовое тело', Post.last.body
    assert_equal @user.id, Post.last.creator_id
  end
end
