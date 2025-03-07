# frozen_string_literal: true

class FixPostUserReference < ActiveRecord::Migration[7.1]
  def change
    remove_reference :posts, :user, foreign_key: true
    add_reference :posts, :creator, foreign_key: { to_table: :users }
  end
end
