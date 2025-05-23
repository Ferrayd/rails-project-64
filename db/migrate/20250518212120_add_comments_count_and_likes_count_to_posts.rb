# frozen_string_literal: true

class AddCommentsCountAndLikesCountToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :comments_count, :integer, default: 0, null: false
    add_column :posts, :likes_count, :integer, default: 0, null: false
  end
end
