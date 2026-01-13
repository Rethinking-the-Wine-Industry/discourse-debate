module Admin
  module Plugins
    class DebateAdminController < Admin::AdminController
      def index
        stats = DebateStat.order(updated_at: :desc).limit(100)

        render_json_dump(
          stats: stats.map do |s|
            {
              topic_id: s.topic_id,
              favor: s.favor,
              neutral: s.neutral,
              against: s.against,
              updated_at: s.updated_at
            }
          end
        )
      end
    end
  end
end
