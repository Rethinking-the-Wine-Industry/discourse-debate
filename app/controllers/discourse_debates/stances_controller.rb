# frozen_string_literal: true
#
module DiscourseDebates
  class StancesController < ::ApplicationController
    requires_plugin "discourse-debates"
    before_action :ensure_logged_in

    def set
      params.require(%i[topic_id stance])

      topic_id = params[:topic_id].to_i
      stance_value = params[:stance]

      stance =
        ::DiscourseDebates::Stance.find_or_initialize_by(
          topic_id: topic_id,
          user_id: current_user.id,
        )

      if stance.updated_at && stance.updated_at > 30.seconds.ago
        render_json_error I18n.t("errors.stance_too_fast")
        return
      end

      return if stance.persisted? && stance.stance == stance_value

      stance.stance = stance_value

      if stance.save
        render json: { success: "OK", stance: stance.stance, topic_id: topic_id }
      else
        render_json_error(stance)
      end
    rescue ArgumentError
      render json: { error: "Invalid stance." }, status: :bad_request
    end
  end
end
