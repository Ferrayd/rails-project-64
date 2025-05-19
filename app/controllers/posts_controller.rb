# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @user_like = current_user ? @post.likes.find_by(user: current_user) : nil
    @form_comment = PostComment.new(post: @post, user: current_user) if user_signed_in?
    @comments = @post.comments.includes(:user).arrange
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_url, notice: t('.success')
    else
      handle_create_failure
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end

  def handle_create_failure
    flash.alert = t('.failure')
    render :new, status: :unprocessable_entity
  end
end
