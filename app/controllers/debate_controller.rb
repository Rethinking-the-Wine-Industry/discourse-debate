class DebateController < ::ApplicationController
  requires_plugin :discourse-debates
  before_action :ensure_logged_in

  def set
    topic = Topic.find(params[:topic_id])
    guardian.ensure_can_see!(topic)

    stance = params[:stance]
    unless %w[favor neutral against].include?(stance)
      return render json: { error: 'invalid stance' }, status: 400
    end

    tu = TopicUser.find_or_create_by(user_id: current_user.id, topic_id: topic.id)

    if !SiteSetting.debate_allow_change && tu.custom_fields['debate_stance']
      return render json: { error: 'cannot change stance' }, status: 403
    end

    tu.custom_fields['debate_stance'] = stance
    tu.custom_fields['debate_anonymous'] = params[:anonymous] == 'true'
    tu.save_custom_fields

    DebateStat.refresh!(topic.id)

    render json: success_json
  end

  def info
    topic = Topic.find(params[:topic_id])
    guardian.ensure_can_see!(topic)
    render_json_dump(DebateInfoSerializer.new(topic))
  end
end
