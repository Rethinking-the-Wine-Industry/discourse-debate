# frozen_string_literal: true

DiscourseDebatesModule::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DiscourseDebatesModule::Engine, at: "discourse-debates" }
