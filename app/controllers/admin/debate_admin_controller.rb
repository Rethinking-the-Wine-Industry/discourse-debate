class Admin::DebateAdminController < Admin::AdminController
  def index
    stats = DebateStat.all.order(updated_at: :desc)
    render_json_dump(stats: stats.map { |s| { topic_id: s.topic_id, favor: s.favor, neutral: s.neutral, against: s.against } })
  end
end
