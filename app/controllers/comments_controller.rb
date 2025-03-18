# frozen_string_literal: true

# class CommentsController < ApplicationController
#   before_action :authenticate_user!

#   def create
#     @post = Post.find(params[:post_id])
#     @comment = @post.post_comments.build(comment_params)
#     @comment.user = current_user
#     if params[:post_comment][:parent_id].present?
#       parent = PostComment.find(params[:post_comment][:parent_id])
#       @comment.parent = parent
#     end
#     if @comment.save
#       redirect_to @post, notice: t('.success')
#     else
#       redirect_to @post, alert: t('.failure')
#     end
#   end

#   private

#   def comment_params
#     params.require(:post_comment).permit(:content)
#   end
# end
class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comment = build_comment(@post)

    if @comment.save
      redirect_to @post, notice: t('.success')
    else
      redirect_to @post, alert: t('.failure')
    end
  end

  private

  def build_comment(post)
    comment = post.post_comments.build(comment_params)
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
end
