# frozen_string_literal: true

class PostComment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy

  belongs_to :post, counter_cache: :comments_count
  belongs_to :user

  validates :content, presence: true
end
