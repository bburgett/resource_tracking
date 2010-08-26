ActionController::Routing::Routes.draw do |map|

  map.data_response_start "data_responses/:id", :controller => 'data_responses', :action => 'start'

  map.data_response_edit "data_responses/:id/edit", :controller => 'data_responses', :action => 'edit'

  map.data_requests 'data_requests', :controller => 'data_requests', :action => :index #until we flesh out this model

  # routes for CSV uploading for various models
  %w[activities funding_flows projects providers funding_sources model_helps comments other_costs organizations users sub_activities].each do |model|
    map.create_from_file model+"/create_from_file", :controller => model, :action => "create_from_file"
    map.create_from_file_form model+"/create_from_file_form", :controller => model, :action => "create_from_file_form"
  end

  map.funding_sources_data_entry "funding_sources",
    :controller => 'funding_sources', :action => 'index'

  map.providers_data_entry "providers",
    :controller => 'providers', :action => 'index'

  map.resources :projects,
    :collection => {:browse => :get},
    :member => {:select => :post}, :active_scaffold => true

  map.resources :organizations,
    :collection => {:browse => :get},
    :member => {:select => :post}, :active_scaffold => true

  map.resources :activities, :active_scaffold => true do |activity|

    activity.resource :budget, :path_prefix => '/activities/:activity_id/classification',
                                :controller => :budget_classification,
                                :only => [ :show, :update ]
    activity.resource :expenditure, :path_prefix => '/activities/:activity_id/classification',
                                      :controller => :expenditure_classification,
                                      :only => [ :show, :update ]
     #TODO : refactor as above
    activity.resource :coding,  :controller => :code_assignments,
                                :only => [:index], #no restful routes k thx
                                :member => {  :budget                      => :get,
                                              :budget_cost_categories      => :get,
                                              :expenditure                 => :get,
                                              :expenditure_cost_categories => :get
                                            }

    map.resources :sub_activities, :active_scaffold => true

    activity.update_coding_budget 'update_coding_budget', :controller => :code_assignments, :action => :update_budget
    activity.update_coding_expenditure 'update_coding_expenditure', :controller => :code_assignments, :action => :update_expenditure

    activity.update_coding_budget_cost_categories 'update_coding_budget_cost_categories', :controller => :code_assignments, :action => :update_budget_cost_categories
    activity.update_coding_expenditure_cost_categories 'update_coding_expenditure_cost_categories', :controller => :code_assignments, :action => :update_expenditure_cost_categories
  end

  # AS redirect helpers
  map.popup_coding 'popup_coding', :controller => :activities, :action => :popup_coding
  map.popup_other_cost_coding "popup_other_cost_coding", :controller => 'other_costs', :action => 'popup_coding'

  map.resources :indicators, :active_scaffold => true
  #map.resources :line_items, :active_scaffold => true
  map.resources :comments, :active_scaffold => true
  map.resources :field_helps, :active_scaffold => true
  map.resources :model_helps, :active_scaffold => true
  map.resources :funding_flows, :active_scaffold => true
  map.resources :codes, :active_scaffold => true
  #map.resources :activity_cost_categories, :active_scaffold => true
  map.resources :other_costs, :active_scaffold => true
  #map.resources :other_cost_types, :active_scaffold => true

  map.resources :users, :active_scaffold => true
  map.resource :user_session

  map.resources :help_requests, :active_scaffold => true

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

  map.reporter_dashboard "reporter_dashboard", :controller => 'static_page', :action => "reporter_dashboard"

  map.static_page ':page',
                  :controller => 'static_page',
                  :action => 'show',
                  :page => Regexp.new(%w[about contact admin_dashboard about news submit user_guide reports].join('|'))

  map.root :controller => 'static_page', :action => 'index' # a replacement for public/index.html

end
