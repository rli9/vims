Vims::Application.routes.draw do
  root :to => 'application#login'

  post 'login', to: 'application#login'
  get 'login', to: 'application#login'
  get 'logout', to: 'application#logout'

  get '/test_target_instances/show_test_report', :controller => 'test_target_instances', :action => 'show_test_report'
  post '/test_target_instances/create_test_results_by_test_case_names', :controller => 'test_target_instances', :action => 'create_test_results_by_test_case_names'
  post '/test_target_instances/delete', :controller => 'test_target_instances', :action => 'delete'
  post '/test_target_instances/delete_test_results_by_test_case_names', :controller => 'test_target_instances', :action => 'delete_test_results_by_test_case_names'
  resources :test_target_instances

  resources :projects

  get '/bug_tracks/config_address', :controller => 'bug_tracks', :action => 'config_address', :id => 0
  get '/bug_tracks/map_bug_to_case', :controller => 'bug_tracks', :action => 'map_bug_to_case', :id => 0
  get '/bug_tracks/test_case_list', :controller => 'bug_tracks', :action => 'test_case_list', :id => 0
  post 'bug_tracks/create_by_test_case_names', :controller => 'bug_tracks', :action => 'create_by_test_case_names'
  resources :bug_tracks

  post '/test_case_template_params/update', :controller => 'test_case_template_params', :action => 'update'
  resources :test_case_template_params

  post '/test_case_template_param_instances/delete', :controller => 'test_case_template_param_instances', :action => 'delete'
  post '/test_case_template_param_instances/update', :controller => 'test_case_template_param_instances', :action => 'update'
  resources :test_case_template_param_instances

  resources :test_case_templates
  resources :test_targets
  resources :message_agents
  resources :test_suites

  get '/test_cases/search', :controller => 'test_cases', :action => 'search'
  post '/test_cases/search', :controller => 'test_cases', :action => 'search'
  resources :test_cases

  resources :change_lists
  resources :test_targets
  resources :test_results

  resources :members
  resources :news
  resources :bits_interpreters
  resources :test_case_priorities

  get '/:controller(/:action(/:id))'
end
