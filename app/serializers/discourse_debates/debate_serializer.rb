module DiscourseDebates
  class DebateSerializer < ::ApplicationSerializer
    attributes :id, :topic_id, :status, :created_at, :updated_at
  end
end
