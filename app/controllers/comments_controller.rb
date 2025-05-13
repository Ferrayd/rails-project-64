# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = build_comment
    if @comment.save
      redirect_to @post, notice: t('.success')
    else
      handle_failed_save
    end
  end

  private

  def build_comment
    @post.comments.build(comment_params.merge(user: current_user))
  end

  def handle_failed_save
    @comments = @post.comments.includes(:user).arrange
    flash.alert = t('.failure', errors: @comment.errors.full_messages.join(', '))
    render 'posts/show', status: :unprocessable_entity
  end

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end
end
