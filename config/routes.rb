Msajili::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'index#index'

  resources :users
  resources :companies
  resources :jobs

  match '/request_demo', to: 'index#demo', via: 'post'
  match 'role', to: 'accounts#role', via: 'get'
  match 'signin', to: 'accounts#signin', via: [:get, :post]
  match 'signout', to: 'accounts#logout', via: 'get'
  match '/password_recovery_tool', to: 'accounts#forgot_password', via: [:get, :post]
  match '/password_reset', to: 'accounts#password_reset', via: [:get, :post]

  match '/calendar', to: 'interviews#calendar', via: 'get'
  match '/interviews', to: 'interviews#list', via: 'get'
  match '/schedule', to: 'interviews#schedule', via: 'post'
  patch '/schedule', to: 'interviews#schedule', via: 'post'

  match '/signup', to: 'users#new', via: 'get'
  match '/userlist', to: 'users#list', via: 'get'
  match '/set_enabled', to: 'users#set_enabled', via: 'post'
  match '/newrecruiter', to: 'users#new_recruiter', via: 'get'
  match '/register', to: 'users#new_admin', via: [:get, :post]
  match '/userapplications', to: 'users#application_list', via: 'get'
  match '/activate', to: 'users#activate', via: 'get'
  match '/resend', to: 'users#resend', via: [:get, :post]

  match '/pricing', to: 'static_pages#pricing', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match 'feedback', to: 'static_pages#feedback', via: 'post'
  match 'home', to: 'static_pages#home', via: 'get'
  match '/help', to: 'static_pages#help', via: 'get'
  match '/features', to: 'static_pages#features', via: 'get'
  match '/tos', to: 'static_pages#terms_n_conditions', via: 'get'
  match '/privacy', to: 'static_pages#privacy_policy', via: 'get'
  match '/test', to: 'static_pages#test', via: [:get, :post]
  match '/mobile', to: 'static_pages#mobile', via: 'get'

  match '/profile', to: 'profile#index', via: 'get'
  match '/editprofile', to: 'profile#edit', via: 'get'
  patch '/saveprofile', to: 'profile#save', via: [:post]

  match '/settings', to: 'settings#index', via: 'get'
  match '/change_password', to: 'settings#change_password', via: 'post'

  match '/dashboard', to: 'dashboard#index', via: 'get'
  match '/dashboardrecruiter', to: 'dashboard#recruiter_index', via: 'get'
  match '/dashboardadmin', to: 'dashboard#admin_index', via: 'get'

  match '/upload', to: 'uploads#upload', via: 'post'
  match '/download', to: 'uploads#download', via: 'get'
  match '/uploads', to: 'uploads#list', via: 'get'
  match '/attached', to: 'uploads#attached_list', via: 'get'
  match '/removeupload', to: 'uploads#remove', via: 'post'
  match '/attach', to: 'uploads#attach', via: 'post'

  match '/recruiters', to: 'dashboard#recruiters', via: 'get'
  match '/company_dashboard', to: 'dashboard#company', via: 'get'
  match '/payments_dashboard', to: 'dashboard#payments', via: 'get'
  match '/jobs_dashboard', to: 'dashboard#jobs', via: 'get'
  match '/templates_dashboard', to: 'dashboard#templates', via: 'get'
  match '/procedures_dashboard', to: 'dashboard#procedures', via: 'get'
  match '/applications_dashboard', to: 'dashboard#applications', via: 'get'
  match '/job_search_dashboard', to: 'dashboard#job_search', via: 'get'

  match '/subscribe', to: 'companies#subscribe', via: [:get, :post]
  match '/editcompany', to: 'companies#edit', via: 'get'
  patch '/savecompany', to: 'companies#save', via: 'post'
  match '/payments', to: 'companies#payments', via: 'get'
  match '/checkout', to: 'companies#checkout', via: 'get'
  match '/order', to: 'companies#order', via: 'post'
  match '/companies', to: 'companies#list', via: 'get'

  match '/pesapalcallback', to: 'pesapal#callback', via: 'get'
  match '/ipnlistener', to: 'pesapal#ipn', via: 'get'

  match '/newtemplateq', to: 'templates#questions', via: 'get'
  match '/createtemplateq', to: 'templates#create', via: 'post'
  match '/showtemplate', to: 'templates#show', via: 'get'
  match '/templatelist', to: 'templates#list', via: 'get'
  patch '/savetemplate', to: 'templates#save', via: 'post'
  match '/edittemplate', to: 'templates#edit', via: 'get'
  match '/inserttemplate', to: 'templates#insert', via: 'get'

  match '/newjob2', to: 'jobs#new_job', via: [:get, :post]
  match '/newjob', to: 'jobs#new', via: 'get'
  match '/customfields', to: 'jobs#edit_fields', via: [:get]
  match '/selectprocedure', to: 'jobs#select_procedure', via: [:get]
  match '/definequestions', to: 'jobs#define_questions', via: [:get]
  match '/setfilter', to: 'jobs#set_filter', via: [:get]
  match '/joblist', to: 'jobs#list', via: 'get'
  match '/showjob', to: 'jobs#show', via: 'get'
  match '/browse', to: 'jobs#browse', via: 'get'
  match '/jobsearch', to: 'jobs#search', via: 'get'
  match '/setstatus', to: 'jobs#set_status', via: 'get'
  match '/applytoken', to: 'jobs#apply_token', via: 'get'
  match '/prescreening', to: 'jobs#screening', via: [:get]
  match 'apply', to: 'jobs#apply', via: [:get, :post]
  match '/savecover', to: 'jobs#save_coverletter', via: 'post'
  match '/saveanswers', to: 'jobs#save_answers', via: 'post'
  match '/completeapplication', to: 'jobs#complete', via: 'post'
  match '/savefilter', to: 'jobs#save_filter', via: 'post'
  match '/updatejob', to: 'jobs#update', via: 'get'

  match 'admin', to: 'admin#index', via: 'get'
  match 'adminsignin', to: 'admin#signin', via: [:get, :post]
  match 'adminsignout', to: 'admin#logout', via: 'get'
  match 'adminusers', to: 'admin#users', via: 'get'
  match 'admincompanies', to: 'admin#companies', via: 'get'
  match 'adminjobs', to: 'admin#jobs', via: 'get'
  match 'adminagents', to: 'admin#agents', via: 'get'
  match 'adminpayments', to: 'admin#payments', via: 'get'
  match 'adminuserlist', to: 'admin#userlist', via: 'get'
  match 'admincompanylist', to: 'admin#companylist', via: 'get'
  match 'adminjoblist', to: 'admin#joblist', via: 'get'
  match 'adminagentrequestlist', to: 'admin#agent_request_list', via: 'get'
  match 'adminpaymentlist', to: 'admin#paymentlist', via: 'get'
  match 'newagent', to: 'admin#new_agent', via: 'get'
  match 'admincompany', to: 'admin#company', via: 'get'
  match 'adminsubscribe', to: 'admin#change_subscription', via: 'post'
  match 'adminmodify_token', to: 'admin#modify_token', via: 'post'
  match 'adminnew_job', to: 'admin#new_job', via: 'get'
  match 'adminupdate_job', to: 'admin#update_job', via: 'patch'
  match 'admincreate_job', to: 'admin#create_job', via: 'post'
  match '/admincustomfields', to: 'admin#edit_fields', via: [:get]
  match '/adminjobstatus', to: 'admin#change_job_status', via: [:get]
  match '/editor', to: 'admin#editor', via: [:get]
  match '/staff', to: 'admin#staff', via: [:get, :post]
  match '/stafflist', to: 'admin#stafflist', via: [:get]
  match '/staff_password', to: 'admin#change_password', via: [:post]
  match '/calculate_popularity', to: 'admin#calculate_popularity', via: [:get]

  match 'agent', to: 'agents#index', via: 'get'
  match 'agentsignin', to: 'agents#signin', via: [:post]
  match 'agentsignout', to: 'agents#logout', via: 'get'
  match 'agenthome', to: 'agents#home', via: 'get'
  match 'agentrequest', to: 'agents#agent_request', via: 'post'
  match 'agentcontacts', to: 'agents#contact_list', via: 'get'

  match '/processjob', to: 'process#index', via: 'get'
  match '/applicationlist', to: 'process#list', via: 'get'
  match '/application', to: 'process#view', via: 'get'
  match '/dropapplicant', to: 'process#drop', via: 'get'
  match '/advanceapplicant', to: 'process#advance', via: 'get'
  match '/createcomment', to: 'process#create_comment', via: 'post'
  match '/selectfilter', to: 'process#filter', via: 'get'
  match '/progress', to: 'process#application', via: 'get'
  match '/procedurelist', to: 'procedures#list', via: 'get'
  match '/createprocedure', to: 'procedures#create', via: 'post'
  match '/newprocedure', to: 'procedures#new', via: 'get'
  match '/editprocedure', to: 'procedures#edit', via: 'get'
  patch '/saveprocedure', to: 'procedures#save', via: 'post'
  match '/insertprocedure', to: 'procedures#insert', via: 'get'
  match '/movestage', to: 'procedures#arrange', via: 'get'

  match '/reports', to: 'reports#index', via: 'get'

  get 'company/:identifier' => 'career_page#jobs', as: :careers
  match '/external', to: 'career_page#display', via: 'get'

  match '/questions', to: 'ajax#questions', via: 'get'
  match '/delete_question', to: 'ajax#delete_question', via: 'post'
  match '/move_question', to: 'ajax#move_question', via: 'post'
  match '/new_question', to: 'ajax#new_question', via: 'post'
  match '/save_questions', to: 'ajax#save_questions', via: 'post'

  match '/delete_choice', to: 'ajax#delete_choice', via: 'post'
  match '/new_choice', to: 'ajax#new_choice', via: 'post'

  match '/job_fields', to: 'ajax#job_fields', via: 'get'
  match '/delete_job_field', to: 'ajax#delete_job_field', via: 'post'
  match '/move_job_field', to: 'ajax#move_job_field', via: 'post'
  match '/new_job_field', to: 'ajax#new_job_field', via: 'post'
  match '/save_fields', to: 'ajax#save_fields', via: 'post'

  get 'sitemap' => 'sitemap#show', format: :xml, as: :sitemap

  match 'api/ping', to: 'api#ping', via: [:get, :post]
  match 'api/sync', to: 'api#sync', via: [:get, :post]
  match 'api/import_sync', to: 'api#import_sync', via: [:get, :post]
  match 'api/data', to: 'api#data', via: [:get, :post]

  match '*path', to: 'errors#page_not_found', via: [:get, :post]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
