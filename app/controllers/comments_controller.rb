# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.post_comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'Комментарий добавлен!'
    else
      redirect_to @post, alert: 'Ошибка при добавлении комментария.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:post_comment).permit(:content, :parent_id)
  end
end
