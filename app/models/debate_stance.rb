# frozen_string_literal: true

class DebateStance < ActiveRecord::Base
  self.table_name = "debate_stances"

  belongs_to :user
  belongs_to :topic

  validates :stance, inclusion: { in: %w[favor neutral against] }
  validates :user_id, uniqueness: { scope: :topic_id }
end
