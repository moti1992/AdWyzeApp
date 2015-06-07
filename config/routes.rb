Rails.application.routes.draw do

  devise_for :users

  root 'user#search_artist'

  get 'user/search' => 'user#search', :as => 'user'
  get 'user/search_artist' => 'user#search_artist', :as => 'artist'
  get 'user/search_history' => 'user#search_history', :as => 'history'
  get 'user/get_similar_artists' => 'user#get_similar_artists', :as => 'get_similar_artists'

end
