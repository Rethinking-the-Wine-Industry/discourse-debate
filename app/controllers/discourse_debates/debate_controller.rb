# frozen_string_literal: true

module ::DebatesModule
  class DiscourseDebates::DebateController < ::ApplicationController
    requires_plugin "discourse-debates"

    def index
      render json: { ok: true }
    end
  end
end
