# frozen_string_literal: true

DiscourseDebates::Engine.routes.draw do
  post "/stance" => "stances#create"
  get "/counts/:topic_id" => "stances#counts"
end