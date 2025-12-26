class DebateEngine < ::Rails::Engine
  engine_name 'debate_engine'
  isolate_namespace DebateEngine

  initializer 'debate_engine.add_routes' do
    Discourse::Application.routes.append do
      post '/debate/:topic_id/stance' => 'debate#set'
      get  '/debate/:topic_id' => 'debate#info'
      get  '/admin/plugins/debate' => 'admin/debate_admin#index'
    end
  end
end
