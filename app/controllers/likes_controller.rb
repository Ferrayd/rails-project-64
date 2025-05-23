# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post.likes.find_or_create_by(user: current_user)
    redirect_back fallback_location: posts_url, notice: t('.success')
  end

  def destroy
    @post_like = PostLike.find_by(user: current_user, post_id: params[:post_id])
    @post_like&.destroy
    redirect_back fallback_location: posts_url, notice: t('.success')
  end
end
