# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :category
  belongs_to :creator, class_name: 'User', inverse_of: :posts
  validates :title, :body, presence: true
  has_many :post_comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy

  def liked_by?(user)
    post_likes.exists?(user: user)
  end
end
