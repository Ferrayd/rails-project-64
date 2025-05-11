# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show]

  def index
    @posts = Post.includes(:category, :creator).order(created_at: :desc)
  end

  def show; end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = build_post

    if @post.save
      redirect_to posts_url, notice: t('.success')
    else
      handle_create_failure
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :category_id)
  end

  def build_post
    current_user.posts.build(post_params.merge(creator: current_user))
  end

  def handle_create_failure
    flash.alert = t('.failure', errors: @post.errors.full_messages.join(', '))
    render :new, status: :unprocessable_entity
  end
end
