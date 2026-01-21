# frozen_string_literal: true

module ::DebatesModule
  class ExamplesController < ::ApplicationController
    requires_plugin "discourse-debates"

    def index
      render json: { ok: true }
    end
  end
end
