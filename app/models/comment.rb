# frozen_string_literal: true

class Comment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy

  belongs_to :post
  belongs_to :user

  validates :content, presence: true
end
