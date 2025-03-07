# frozen_string_literal: true

class PostComment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy

  belongs_to :post
  belongs_to :user

  validates :content, presence: true
end
