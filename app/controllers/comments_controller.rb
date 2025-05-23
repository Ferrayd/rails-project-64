# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = build_comment
    if @comment.save
      redirect_to @post, notice: t('.success')
    else
      flash[:alert] = t('.failure', errors: @comment.errors.full_messages.to_sentence)
      redirect_to @post
    end
  end

  private

  def build_comment
    @post.comments.build(comment_params.merge(user: current_user))
  end

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end
end
