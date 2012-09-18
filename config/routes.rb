Pns::Application.routes.draw do
  # root is set to upload CSV page
  root :to => 'location#upload'

  # routes for collection : location : routes for html
  match "location/upload" => "location#upload"
  match "location/show" => "location#show"

  # routes for collection : location : API routes
  match "location/all" => "location#all" # get all locations
end
