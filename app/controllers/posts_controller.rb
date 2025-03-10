# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show destroy edit update]

  def index
    @posts = Post.includes(:category, :creator).order(created_at: :desc)
  end

  def show; end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params.merge(creator: current_user))
    if @post.save
      redirect_to posts_url, notice: 'Пост успешно создан.'
    else
      render :new
    end
  end
  
  def edit; end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Пост удалён"
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path
    else
      alert "Ошибка обновления: #{@post.errors.full_messages}"
      render :edit, status: :unprocessable_entity
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
