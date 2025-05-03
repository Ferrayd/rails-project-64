# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comment = build_comment(@post)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: t('.success')
    else
      handle_create_failure
    end
  end

  private

  def build_comment(post)
    comment = post.comments.build(comment_params)
    comment.user = current_user
    assign_parent_comment(comment)
    comment
  end

  def assign_parent_comment(comment)
    return if params[:post_comment][:parent_id].blank?

    parent = PostComment.find(params[:post_comment][:parent_id])
    comment.parent = parent
  end

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end

  def handle_create_failure
    flash.alert = t('.failure', errors: @post.errors.full_messages.join(', '))
    render 'posts/show', status: :unprocessable_entity
  end
end
