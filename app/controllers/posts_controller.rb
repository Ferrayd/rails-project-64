# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: [:show]

  def index
    @posts = Post.includes(:category, :user).order(created_at: :desc)
  end

  def show; end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params.merge(creator: current_user))
    if @post.save
      redirect_to @post, notice: 'Пост успешно создан.'
    else
      render :new
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end
end
