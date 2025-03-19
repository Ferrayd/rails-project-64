# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @post.likes.find_or_create_by(user: current_user)
    redirect_to posts_url, notice: t('.success')
  end

  def destroy
    like = Like.find(params[:id])
    if like.user == current_user
      like.destroy!
      redirect_to posts_url, notice: t('.success')
    else
      redirect_to posts_url, alert: t('.failure')
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
