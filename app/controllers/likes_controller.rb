# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @post.post_likes.create(user: current_user)
    redirect_to posts_url, notice: t('.success')
  end

  def destroy
    like = @post.post_likes.find_by(user: current_user)
    like.destroy!
    redirect_to posts_url, notice: t('.success')
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
