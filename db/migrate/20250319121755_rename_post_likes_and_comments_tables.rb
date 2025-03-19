# frozen_string_literal: true

class RenamePostLikesAndCommentsTables < ActiveRecord::Migration[7.1]
  def change
    rename_table :post_likes, :likes
    rename_table :post_comments, :comments

    remove_foreign_key :likes, :posts
    remove_foreign_key :likes, :users
    remove_foreign_key :comments, :posts
    remove_foreign_key :comments, :users

    add_foreign_key :likes, :posts
    add_foreign_key :likes, :users
    add_foreign_key :comments, :posts
    add_foreign_key :comments, :users

    rename_index :likes, 'index_post_likes_on_user_id', 'index_likes_on_user_id'
    rename_index :likes, 'index_post_likes_on_post_id', 'index_likes_on_post_id'
    rename_index :likes, 'index_post_likes_on_user_id_and_post_id', 'index_likes_on_user_id_and_post_id'

    rename_index :comments, 'index_post_comments_on_user_id', 'index_comments_on_user_id'
    rename_index :comments, 'index_post_comments_on_post_id', 'index_comments_on_post_id'
    rename_index :comments, 'index_post_comments_on_ancestry', 'index_comments_on_ancestry'
  end
end
