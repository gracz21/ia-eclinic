Rails.application.routes.draw do

  root 'static_pages#home'
  
  get 'appointments/doctor_options', as: :doctor_options
  get 'appointments/get_assignment_id', as: :get_assignment_id
  get 'appointments/hour_options', as: :hour_options
  
  resources :appointments
  
  get 'clinics/clinic_get_free_appointments', as: :clinic_get_free_appointments
  resources :clinics
  
  get 'doctors/doctor_get_free_appointments', as: :doctor_get_free_appointments
  resources :doctors do
    get 'schedules/get_assignment_id_s', as: :get_assignment_id_s
    resources :schedules
  end
  resources :patients

  scope "auth" do
    devise_for :doctors
    devise_for :patients
    devise_for :admins
  end
  
  post 'appointments/first_free_doctor/:doctor_id' => 'appointments#first_free_doctor', as: :appointment_first_free_doctor
  post 'appointments/first_free_clinic/:clinic_id' => 'appointments#first_free_clinic', as: :appointment_first_free_clinic
  post 'appointments/confirm_appointment/:id' => 'appointments#confirm_appointment', as: :appointment_confirm
  post 'patients/activate/:id' => 'patients#activate', as: :activate_patient
  patch 'doctors/:id/assign' => 'doctors#assign_clinic', as: :doctor_assign_clinic
  patch 'doctors/:id/unassign' => 'doctors#unassign_clinic', as: :doctor_unassign_clinic

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
