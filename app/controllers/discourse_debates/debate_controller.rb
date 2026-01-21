module DiscourseDebates
  class DebateController < ::ApplicationController
    requires_plugin "discourse-debates"

    def index
      render json: { ok: true }
    end
  end
end
