Rails.application.routes.draw do
  root to: 'map_display#map'

  post '/faq', to: 'map_display#faq'
  post '/feedback', to: 'map_display#create_feedback'
  post '/save_statistics', to: 'map_display#save_statistics'
  post '/admin/:library/:floor', to: 'admin#map'
  post '/admin/save_svg/:library/:floor', to: 'admin#save_svg'
  post '/admin/save_element/:library/:floor', to: 'admin#save_element'

  get '/faq', to: 'map_display#faq'
  get '/admin', to: 'admin#index'
  get '/feedback', to: 'map_display#feedback'
  get '/:library/:floor', to: 'map_display#map'
  get '/admin/:library/:floor',to: 'admin#map'

  delete '/admin/:library/:floor', to: 'admin#destroy'
end
