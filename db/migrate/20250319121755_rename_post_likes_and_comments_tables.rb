# frozen_string_literal: true

class RenamePostLikesAndCommentsTables < ActiveRecord::Migration[7.1]
  def change
    rename_table :post_likes, :likes

    remove_foreign_key :likes, :posts
    remove_foreign_key :likes, :users

    add_foreign_key :likes, :posts
    add_foreign_key :likes, :users

    rename_index :likes, 'index_post_likes_on_user_id', 'index_likes_on_user_id'
    rename_index :likes, 'index_post_likes_on_post_id', 'index_likes_on_post_id'
    rename_index :likes, 'index_post_likes_on_user_id_and_post_id', 'index_likes_on_user_id_and_post_id'
  end
end
