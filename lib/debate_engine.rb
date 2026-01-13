Discourse::Application.routes.append do
  post "/debate/:topic_id/stance" => "debate#set"
  get  "/debate/:topic_id" => "debate#info"

  namespace :admin, constraints: StaffConstraint.new do
    namespace :plugins do
      get "/debate" => "debate_admin#index"
    end
  end
end
